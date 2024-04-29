graphin_sources = (
  [blueprints, resources] + files(
    'layouts/chart-bar-serie.vala',
    'layouts/chart-line-serie.vala',
    'application.vala',
    'chart-axis.vala',
    'chart-drawable.vala',
    'chart-gesture-handler.vala',
    'chart-grid.vala',
    'chart-parameters.vala',
    'chart-serie.vala',
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
