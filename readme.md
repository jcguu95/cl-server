# DEPRECATED

This project is deprecated. Here are some of my expectation and how they did
not work out.

1. I aimed to write a tiny client that talks to a running lisp repl. The
   functionality should be a essential subset of `lserver`. The code should be
   concise and straightforward.
2. The client should start fast, but I forgot this and chose to use shell. Of
   course, it is not so fast, but I do not know C well enough either. I can
   come back months later when my C skill is better.
3. Probably the hardest part is the rpc protocol. I was not awared well enough
   that how the protocol should be designed. Lisp is rich but shell only speaks
   texts. How should the result from the server be formatted? Remember that
   even if the client is written in C, the server is meant to output to a shell
   pipe.

   ```
   $ ls -al | lisp-server "(magic-transformer *input*)" | ..
   ```

## IDEAS

1. Look at how [`daveray/clawk`](https://github.com/daveray/clawk) deals with
   outputs. Also see alecthomas/pawk.

2. Look at the advantage of
   [nushell](https://gitlab.com/ambrevar/ambrevar.gitlab.io/-/issues/22).
