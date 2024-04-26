graphin_sources = (
  [blueprints, resources] + files(
    'layouts/chart-bar.vala',
    'application.vala',
    'chart-axis.vala',
    'chart-gesture-handler.vala',
    'chart-grid.vala',
    'chart.vala',
    'main.vala',
    'point.vala',
    'window.vala',
  )
)

graphin_vala_args = [
  '--vapidir',
  meson.current_source_dir(),
  '--gresources',
  resource_files,
  '--gresourcesdir=data/',
]

executable(
  'graphin',
  graphin_sources,
  dependencies: graphin_deps,
  vala_args: graphin_vala_args,
  link_args: ['-lm'],
  install: true,
)
