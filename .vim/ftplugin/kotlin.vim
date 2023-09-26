let b:ale_linters = ['languageserver']

let s:kotlin_linters = ale#linter#GetAll(['kotlin'])
let s:kotlin_lsp = filter(copy(s:kotlin_linters), 'v:val[''name''] == ''languageserver'' ')[0]
let s:lsp_config = get(s:kotlin_lsp, 'lsp_config', {})

" Hackity hack, edit the lsp config to target 1.8
" At the time, 1.8 was the latest the LS supported
let s:kotlin_lsp.lsp_config = extend(s:lsp_config, {
\  'kotlin': {
\    'compiler': {
\      'jvm': {
\       'target': '1.8'
\      }
\    }
\  }
\})
