<!--
SPDX-FileCopyrightText: 2025 FreshlyBakedCake

SPDX-License-Identifier: MIT
-->

# Welcome to the *patisserie*

*~ your one-stop-cake-shop for everything Freshly Baked has to offer ~*

## Structure

*Patisserie* is a [monorepo](https://en.wikipedia.org/wiki/Monorepo), which means
there are multiple projects hosted here. Here's a list!

| Project           | Shortcode | Description                                                                                       |
| ----------------- | --------- | ------------------------------------------------------------------------------------------------- |
| [*menu*][m]       | m         | Our URL shortening and [*golinks*][golinks] ("Quickly get to what you want to order")             |
| [*packetmix*][pm] | pm        | Our [*NixOS*](https://nixos.org) configurations ("All you need to bake a delicious system")       |
| [*sprinkles*][s]  | s         | Our [*Niri*](https://github.com/YaLTeR/niri) widgets ("Add some decoration to your Niri desktop") |

[m]: https://tangled.org/@freshlybakedca.ke/patisserie/tree/main/menu
[pm]: https://tangled.org/@freshlybakedca.ke/patisserie/tree/main/packetmix
[s]: https://tangled.org/@freshlybakedca.ke/patisserie/tree/main/sprinkles

[golinks]: https://golinks.github.io/golinks/

Projects are developed in individual directories, and have a workspace file in
`projects/${name}` to help you clone them down with everything they need.

Shortcodes are used in commit messages as the first component of the area name
in [Conventional Commit style](https://conventionalcommits.org). For example,
feature commits to PacketMix should start with something like `feat(pm/...):`.
For commits that affect all areas, the special shortcode `*` is used.

## Cloning a single project

You may clone and push to *patisserie* via [*tangled*](https://tangled.sh) as
you usually would. If you'd like to clone only a single project, however, we
provide a public [*josh* proxy](https://josh-project.github.io/josh/) which can
be used to filter your clone:

```bash
git clone https://git.freshlybakedca.ke/patisserie.git:workspace=projects/packetmix.git
# Swap out the "packetmix" at the end of the command for whatever project you want to clone
```

If you need to push then, as with *tangled* normally, you are required to use
SSH.

*Josh* can push via SSH, but requires you to forward your SSH agent to
authenticate your push:

```ssh-config
# In ~/.ssh/config
Host git.freshlybakedca.ke
  User git
  ForwardAgent yes
```

When you've added this section to your ssh config, you can add a custom push URL
to use SSH.

```bash
git remote set-url --push ssh://git@git.freshlybakedca.ke/patisserie.git:workspace=projects/packetmix.git
# Swap out "packetmix" at the end of the URL for whatever project you have cloned
```

Except for when creating branches, pushing will work as-normal for SSH clones.

### Creating new branches

When pushing to *josh*, creating branches won't work on a regular `git push`.
This is because *josh* doesn't know what state you want the rest of the
repository to be for your branch

You can tell *josh* by providing the `base=` push option like so:

```bash
git push origin HEAD:my-new-branch -o base=main
```

If you're using a git frontend (e.g. [Jujutsu](https://jj-vcs.github.io/jj))
which does not allow you to set push options, you may find it useful to
temporarily set them through the git configuration while performing git
operations. In Jujutsu, you might do that through these aliases:

```toml
[aliases]
josh-push-base-main = [ 'util', 'exec', '--', 'sh', '-c', 'git config push.pushOption base=main && jj git push "$@"; git config --unset push.pushOption', '--' ]
josh-push-create = [ 'util', 'exec', '--', 'sh', '-c', 'git config push.pushOption create && jj git push "$@"; git config --unset push.pushOption', '--' ]
josh-push-force = [ 'util', 'exec', '--', 'sh', '-c', 'git config push.pushOption force && jj git push "$@"; git config --unset push.pushOption', '--' ]
josh-push-merge = [ 'util', 'exec', '--', 'sh', '-c', 'git config push.pushOption merge && jj git push "$@"; git config --unset push.pushOption', '--' ]
```

You must make sure you always unset the push option, even if your push failed.
Pushing with unexpected push options can cause accidental and annoying-to-fix
actions to be taken on your behalf

### Signing commits

As *josh*  rewrites commits, they will not be validly signed everywhere.
We therefore recommend you turn off commit signing for *patisserie* or any
subprojects which you clone down

For example,

```bash
git config commit.gpgsign false
```

or

```bash
jj config set --repo git.sign-on-push false
```
