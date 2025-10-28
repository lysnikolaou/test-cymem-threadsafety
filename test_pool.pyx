from collections import deque
import threading

from cymem.cymem cimport Pool


def test_concurrent_pool_operations():
    cdef Pool pool = Pool()
    cdef int num_threads = 10
    cdef int ops_per_thread = 100
    errors = []

    def worker(thread_id):
        cdef Pool p = pool
        cdef void* ptr
        cdef void* old_ptr
        cdef void* new_ptr
        cdef int i
        cdef size_t addr

        try:
            ptrs = deque()
            # Pre-allocate some memory so realloc/free have work to do
            for _ in range(5):
                ptr = p.alloc(1, 64)
                ptrs.append(<size_t>ptr)

            for i in range(ops_per_thread):
                op = i % 3

                if op == 0:  # alloc
                    ptr = p.alloc(1, 64)
                    ptrs.append(<size_t>ptr)
                elif op == 1 and ptrs:  # free
                    addr = <size_t>ptrs.popleft()
                    ptr = <void*>addr
                    p.free(ptr)
                elif op == 2 and ptrs:  # realloc
                    addr = <size_t>ptrs.popleft()
                    old_ptr = <void*>addr
                    new_ptr = p.realloc(old_ptr, 128)
                    ptrs.append(<size_t>new_ptr)

            # Cleanup remaining allocations
            for addr_obj in ptrs:
                addr = <size_t>addr_obj
                ptr = <void*>addr
                p.free(ptr)
        except Exception as e:
            errors.append((thread_id, e))

    threads = [threading.Thread(target=worker, args=(i,)) for i in range(num_threads)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

    assert not errors, f"Thread errors: {errors}"
    assert pool.size == 0, f"Pool size should be 0, got {pool.size}"
    assert len(pool.addresses) == 0, f"Pool addresses should be empty, got {len(pool.addresses)}"
