// DuskMoon's minimal support for bundled C++ Tree-sitter Wasm scanners.
// Scanner/parser logic is upstream code. Successful allocations use the official
// runtime's malloc/free imports; unrecoverable C++ allocation/library failures
// trap rather than introducing WASI process/stdio/exception dependencies.
#include <cstddef>
#include <cstdlib>
#include <new>

void *operator new(std::size_t size) {
  void *pointer = std::malloc(size ? size : 1);
  if (!pointer) __builtin_trap();
  return pointer;
}

void operator delete(void *pointer) noexcept { std::free(pointer); }
void operator delete(void *pointer, std::size_t) noexcept { std::free(pointer); }

_LIBCPP_BEGIN_NAMESPACE_STD
[[noreturn]] void __libcpp_verbose_abort(const char *, ...) noexcept { __builtin_trap(); }
_LIBCPP_END_NAMESPACE_STD
