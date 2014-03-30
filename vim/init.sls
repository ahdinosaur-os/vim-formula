{% from "vim/map.jinja" import vim with context %}

vim:
  pkg.installed:
    - name: {{ vim.pkg }}

neobundle:
  git.latest:
    - name: https://github.com/Shougo/neobundle.vim.git
    - target: {{ vim.share_dir }}/bundle/neobundle.vim
  file.directory:
    - name: {{ vim.share_dir }}/bundle
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - mode
    - require:
      - git: neobundle

vimrc_local:
  file.managed:
    - name: {{ vim.share_dir }}/vimrc.local
    - source: salt://vim/vimrc.local
    - mode: 644
    - require:
      - pkg: vim
      - git: neobundle