module.exports = {
    name: 'mix_compile',
    cmd: "mix",
    args: [ 'compile', '--warnings-as-errors' ],
    sh: false,
    errorMatch: [ '\\*\\*\\s{1}\\((?<errorType>[a-zA-Z]+)\\)\\s{1}(?<file>[\\/0-9a-zA-Z\\\\._-]+).*\\s{1}starting at line\\s{1}(?<line>\\d+)',
                  '\\*\\*\\s{1}\\((?<errorType>[a-zA-Z]+)\\)\\s{1}(?<file>[\\/0-9a-zA-Z\\\\._-]+):(?<line>\\d+)',
                  '(?<file>[\\/0-9a-zA-Z\\\\._-]+):(?<line>\\d+):\\s{1}warning:\\s{1}(?<warningReason>.*)' ],
    keymap: 'ctrl-c ^c a b',
    targets: {
      mix_test: {
        name: 'mix-test',
        cmd: "mix",
        args: [ 'test' ],
        sh: false,
        errorMatch: [ '(?<file>[\\/0-9a-zA-Z\\\\._-]+):(?<line>\\d+)' ],
        keymap: 'ctrl-c ^c a t'
      },
      mix_clean: {
        name: 'mix-clean',
        cmd: "mix",
        args: [ 'clean' ],
        sh: false,
        keymap: 'ctrl-c ^c a c'
      },
      mix_dialyzer: {
        name: 'mix-dialyzer',
        cmd: "mix",
        args: [ 'dialyzer', '--fullpath' ],
        sh: false,
        errorMatch: [ '(?<file>[\\/0-9a-zA-Z\\\\._-]+):(?<line>\\d+):\\s{1}(?<info>.*)' ],
        keymap: 'ctrl-c ^c a d'
      }
    }
};
