# cl-server

## Goal

Elisp has `emacsclient --eval`, clojure has `babashka`, and 
common lisp will have `cl-server`.

``` shell
# The following are not implemented and designed yet. Just some thought.
$ echo "0 1 2 3 4" | lisp '(nth 2 *input*)' 
2
$ ls | lisp '(take 2 *input*)'
("CHANGES.md" "Dockerfile")
$ ls | lisp '(filter #\'directory? *input*)'
("doc" "resources" "sci" "script" "src" "target" "test")
```

``` lisp
; Need a DSL to quickly transform *input*. 
; For example, #il could mean (listify *input*).

listify: 
    "1 2"  -> ("1" "2")
listify: 
    "1\n2" -> (("1") ("2"))
(listify ","): 
    "1,2"  -> ("1" "2")
str-num:
    ("1" "2") -> (1 2)
str-file:
    ("a.txt" "b.txt") -> (#P"a.txt" #P"b.txt")
read-:
    "(1 2)" -> (1 2)
read-:
    "1 2" -> (values 1 2)

```

## Reference

+ [A related
  discussion](https://www.reddit.com/r/Common_Lisp/comments/owgrie/ways_to_talk_to_a_lisp_repl_a_brief_survey/)
+ [Emacsclient](https://www.emacswiki.org/emacs/EmacsClient)
+ [Babashka](https://github.com/babashka/babashka)

  ``` shell
  # Babashka ::
  $ ls | bb -i '(filter #(-> % io/file .isDirectory) *input*)'
  ("doc" "resources" "sci" "script" "src" "target" "test")
  bb took 4ms.
  $ ls | bb -i '(take 2 *input*)'
  ("CHANGES.md" "Dockerfile")
  $ bb '(vec (dedupe *input*))' <<< '[1 1 1 1 2]'
  [1 2]
  ```
