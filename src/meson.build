graphin_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
]

graphin_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

graphin_sources += gnome.compile_resources('graphin-resources',
  'graphin.gresource.xml',
  c_name: 'graphin'
)

executable('graphin', graphin_sources,
  dependencies: graphin_deps,
       install: true,
)
