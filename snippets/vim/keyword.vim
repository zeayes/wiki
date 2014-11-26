" set buffer iskeyword
let b:keywords = exists('g:coloresque_keywords') ? g:coloresque_keywords : []
for keyword in b:keywords
    exe printf('set iskeyword+=%s', keyword)
endfor
