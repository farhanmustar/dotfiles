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

## PPA list for Ubuntu

PPA for neovim
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -yu
sudo apt-get install neovim -y
sudo update-alternatives --install $(which vim) vim $(which nvim) 50
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100
```

PPA for universal-ctags (for older ubuntu)
```bash
sudo add-apt-repository ppa:hnakamur/universal-ctags -yu
sudo apt-get install universal-ctags -y
```

PPA for ripgrep (for older ubuntu)
```bash
sudo add-apt-repository ppa:x4121/ripgrep -yu
sudo apt-get install ripgrep -y
```

## Vim-Ale linter list
* In vim, run `:ALEInfo` to find list of available linter.

## Language Config

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
<!-- debugger -->
* debugpy
  * debugger for python app by simply prefix with `python -m debugpy`.
```bash
pip install debugpy
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
* ccls
  * seems to be faster then clangd.
  ```bash
  git clone --depth=1 --recursive https://github.com/MaskRay/ccls
  cd ccls
  wget -c http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
  tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
  cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$PWD/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04
  cmake --build Release
  ```
<!-- debugger -->
* codelldb
  * get download url from [vscode-lldb](https://github.com/vadimcn/vscode-lldb/releases) release page.
  * download and extract using unzip.
  * then link to bin path.
  ```bash
  wget https://github.com/vadimcn/vscode-lldb/releases/download/v1.7.0/codelldb-x86_64-linux.vsix
  unzip codelldb-x86_64-linux.vsix
  ln -sT <codelldb>/extension/adapter/codelldb /usr/bin/codelldb
  ```

### Node
<!-- debugger -->
* node-debug2
  * need to clone and build on the same path since nvim config use that path.
  ```bash
  git clone https://github.com/microsoft/vscode-node-debug2.git ~/.bin/vscode-node-debug2
  cd ~/.bin/vscode-node-debug2
  npm install
  npm run build
  ```

### Ros
* [ale-roslint](https://github.com/farhanmustar/ale-roslint)
  * vimrc `Plugin 'farhanmustar/ale-roslint'`

### Javascript
* tsserver (language server for javascript and typescript)
```bash
npm install -g typescript
```
* chrome debugger client
```bash
git clone https://github.com/Microsoft/vscode-chrome-debug ~/.bin/vscode-chrome-debug
cd ~/.bin/vscode-chrome-debug
npm install
npm run build
# run chrome/chromium-browser in debug mode.
google-chrome-stable --remote-debugging-port=9222
```

### Dart
* Tagbar support
  * Instal dart ctags.
```bash
git clone https://github.com/yoehwan/dart-ctags.git
cd dart_ctags
dart pub global activate -s path .
// or convert to native (exp for win)
cd dart_ctags
dart compile exe ./bin/dart_ctags.dart
```

### Golang
* gopls language server
```bash
go install golang.org/x/tools/gopls@latest
```

### Lua
* luacheck linter
```bash
sudo apt install lua-check
```

### Terminal Apps
* tldr
```bash
sudo apt install tldr
tldr -u
```

### Things to explore
Push x11 session over vnc (mirror exisiting display).
```bash
sudo apt install x11vnc
```
