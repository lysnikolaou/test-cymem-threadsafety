project(
  'test-cymem-threadsafety',
  'cython',
  version: '0.1.0',
)

py = import('python').find_installation(pure: false)
dep_py = py.dependency()

cy = meson.get_compiler('cython')
if cy.version().version_compare('>=3.1.0')
    add_project_arguments('-Xfreethreading_compatible=true', language : 'cython')
endif


py.extension_module(
    'test_pool',
    'test_pool.pyx',
    dependencies : dep_py,
    install: true,
    subdir: 'test_cymem_threadsafety',
)

install_subdir('tests', install_dir: py.get_install_dir() / 'test_cymem_threadsafety' / 'tests')
