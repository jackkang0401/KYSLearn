# StripedMap

##### 1.StripedMap

```

template<typename T>
class StripedMap {
#if TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
    enum { StripeCount = 8 };
#else
    enum { StripeCount = 64 };
#endif

    struct PaddedT {
        T value alignas(CacheLineSize); // alignas关键字,设置内存中对齐方式,最小是8字节对齐,可以是16,32,64,128等
    };

    PaddedT array[StripeCount];

    static unsigned int indexForPointer(const void *p) {
        uintptr_t addr = reinterpret_cast<uintptr_t>(p); // 处理无关类型之间的转换；产生一个新值，与原始参数有完全相同的比特位
        return ((addr >> 4) ^ (addr >> 9)) % StripeCount;
    }

 public:
    T& operator[] (const void *p) { 
        return array[indexForPointer(p)].value; 
    }
    const T& operator[] (const void *p) const { 
        return const_cast<StripedMap<T>>(this)[p]; 
    }
};

```

##### 2.SideTable

```
// We cannot use a C++ static initializer to initialize SideTables because
// libc calls us before our C++ initializers run. We also don't want a global 
// pointer to this struct because of the extra indirection.
// Do it the hard way.
alignas(StripedMap<SideTable>) static uint8_t 
    SideTableBuf[sizeof(StripedMap<SideTable>)];    // 定义了一个 sizeof(StripedMap<SideTable>) 大小，类型为 uint8_t 的数组

static void SideTableInit() {
    new (SideTableBuf) StripedMap<SideTable>();
}

// 将 SideTableBuf 转换为 StripedMap<SideTable>& 并返回（ SideTableBuf 内就一个 StripedMap<SideTable> 对象）
static StripedMap<SideTable>& SideTables() {
    return *reinterpret_cast<StripedMap<SideTable>*>(SideTableBuf);
}
```

```
struct SideTable {
    spinlock_t slock;
    RefcountMap refcnts;
    weak_table_t weak_table;

    SideTable() {
        memset(&weak_table, 0, sizeof(weak_table));
    }

    ~SideTable() {
        _objc_fatal("Do not delete SideTable.");
    }

    void lock() { slock.lock(); }
    void unlock() { slock.unlock(); }
    void forceReset() { slock.forceReset(); }

    // Address-ordered lock discipline for a pair of side tables.

    template<HaveOld, HaveNew>
    static void lockTwo(SideTable *lock1, SideTable *lock2);
    template<HaveOld, HaveNew>
    static void unlockTwo(SideTable *lock1, SideTable *lock2);
};
```

##### 3.RefcountMap

```

// RefcountMap disguises its pointers because we 
// don't want the table to act as a root for `leaks`.
typedef objc::DenseMap<DisguisedPtr<objc_object>,size_t,true> RefcountMap;

```

```
template<typename KeyT, typename ValueT,
         bool ZeroValuesArePurgeable = false, 
         typename KeyInfoT = DenseMapInfo<KeyT> >
class DenseMap
    : public DenseMapBase<DenseMap<KeyT, ValueT, ZeroValuesArePurgeable, KeyInfoT>,
                          KeyT, ValueT, KeyInfoT, ZeroValuesArePurgeable> {
    // Lift some types from the dependent base class into this class for
    // simplicity of referring to them.
    typedef DenseMapBase<DenseMap, KeyT, ValueT, KeyInfoT, ZeroValuesArePurgeable> BaseT;
    typedef typename BaseT::BucketT BucketT;
    friend class DenseMapBase<DenseMap, KeyT, ValueT, KeyInfoT, ZeroValuesArePurgeable>;

    BucketT *Buckets;
    unsigned NumEntries;
    unsigned NumTombstones;
    unsigned NumBuckets;
}

```

##### 4.weak_table_t

```

/**
 * The global weak references table. Stores object ids as keys,
 * and weak_entry_t structs as their values.
 */
struct weak_table_t {
    weak_entry_t *weak_entries;
    size_t    num_entries;
    uintptr_t mask;
    uintptr_t max_hash_displacement;
};

```

##### 5.weak_entry_t

```
struct weak_entry_t {
    DisguisedPtr<objc_object> referent;     // 所指对象地址
    union {
        struct {
            weak_referrer_t *referrers;     // weak 对象数，大于 WEAK_INLINE_COUNT 时，变为此数据结构
            uintptr_t        out_of_line_ness : 2;
            uintptr_t        num_refs : PTR_MINUS_2;
            uintptr_t        mask;
            uintptr_t        max_hash_displacement;
        };
        struct {
            // out_of_line_ness field is low bits of inline_referrers[1]
            weak_referrer_t  inline_referrers[WEAK_INLINE_COUNT];   // weak 对象
        };
    };

    bool out_of_line() {
        return (out_of_line_ness == REFERRERS_OUT_OF_LINE);
    }
};

```

##### 6. weak_referrer_t

```

// The address of a __weak variable.
// These pointers are stored disguised so memory analysis tools
// don't see lots of interior pointers from the weak table into objects.
typedef DisguisedPtr<objc_object *> weak_referrer_t;

```
