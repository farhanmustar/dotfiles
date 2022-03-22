Configuration files.

Usage:

```bash
git clone https://github.com/farhanmustar/dotfiles ~/dotfiles
rsync -a ~/dotfiles/ ~
rm -rf ~/dotfiles
```

This configuration require vim 8.0. Older ubuntu system need to update vim using third party source.
```bash
sudo add-apt-repository ppa:jonathonf/vim -yu
sudo apt-get install vim -y
```

PPA for neovim build and install command
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -yu
sudo apt-get install neovim -y
```

PPA for universal-ctags
```bash
sudo add-apt-repository ppa:hnakamur/universal-ctags -yu
sudo apt-get install universal-ctags
```

PPA for ripgrep
```bash
sudo add-apt-repository ppa:x4121/ripgrep -yu
sudo apt-get install ripgrep
```

## Vim-Ale linter list
* In vim, run `:ALEInfo` to find list of available linter.

### Vim
* [vimls](https://github.com/iamcco/vim-language-server)
```bash
npm install -g vim-language-server
```

### Python
* [ale-python-linter](https://github.com/farhanmustar/ale-python-linter)
  * vimrc `Plugin 'farhanmustar/ale-python-linter'`
* jedi-language-server (jedils)
  * language server for python.
```bash
pip install jedi-language-server
```

* python-language-server (pyls)
  * language server for python. (available for python 2.7)
```bash
pip install python-language-server
```
* flake8
  * more detail checker especially in code formatting.
```bash
pip install flake8
```
* bandit
  * security issue checker.
```bash
pip install bandit
```

### C++
* clangd
  * Download binary file from [clangd github](https://github.com/clangd/clangd/releases/) release page.
    * Copy to bin dir.
  * for ROS development set env variable using shell or in vimrc
    * `let $CPLUS_INCLUDE_PATH='/home/user/ws/devel/include/:/opt/ros/melodic/include/'`
  * or run this command to generate the `compile_command.json`.
    * bash aliased to `catkin_make_compile_commands`
    * `catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1`
    * then link the generated `compile_command.json` file to outside the build folder for ale to find.
      * `ln -sT /home/user/ws/build/compile_command.json /home/user/ws/compile_command.json`

### Ros
* [ale-roslint](https://github.com/farhanmustar/ale-roslint)
  * vimrc `Plugin 'farhanmustar/ale-roslint'`

### Javascript
* tsserver (language server for javascript and typescript)
```bash
npm install -g typescript
```

### Dart
* Tagbar support
  * Instal dart ctags.
```bash
dart pub global activate dart_ctags
```
