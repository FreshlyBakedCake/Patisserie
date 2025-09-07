# Welcome to the *patisserie*

*~ your one-stop-cake-shop for everything Freshly Baked has to offer ~*

## Structure

*Patisserie* is a [monorepo](https://en.wikipedia.org/wiki/Monorepo), which means
there are multiple projects hosted here. Here's a list!

| Project     | Description                                                                                 |
| ----------- | ------------------------------------------------------------------------------------------- |
| *packetmix* | Our [*NixOS*](https://nixos.org) configurations ("All you need to bake a delicious system") |

## Cloning a single project

You may clone and push to *patisserie* via [*tangled*](https://tangled.sh) as
you usually would. If you'd like to clone only a single project, however, we
provide a public [*josh* proxy](https://josh-project.github.io/josh/) which can
be used to filter your clone:

```bash
git clone https://git.freshlybakedca.ke/patisserie.git:/packetmix.git
# Swap out "packetmix" at the end of the URL for whatever project you want to clone
```

If you need to push then, as with *tangled* normally, you are required to use
SSH.

*Josh* can push via SSH, but requires you to forward your SSH agent to
authenticate your push:

```ssh-config
# In ~/.ssh/config
Host git.freshlybakedca.ke
  Hostname teal
  # ^ Pushing can currently only be done from inside our Tailscale network. We are considering solutions to this limitation
  User git
  ForwardAgent yes
```

When you've added this section to your ssh config, you can clone over SSH.
Except for when creating branches, pushing will work as-normal for SSH clones.

```bash
git clone ssh://git@git.freshlybakedca.ke/patisserie.git:/packetmix.git
# Swap out "packetmix" at the end of the URL for whatever project you want to clone
```

### Creating new branches

When pushing to *josh*, creating branches won't work on a regular `git push`.
This is because *josh* doesn't know what state you want the rest of the
repository to be for your branch

You can tell *josh* by providing the `base=` push option like so:

```bash
git push origin HEAD:my-new-branch -o base=main
```

If you want to always pick `main` by default you can set this in your
repository-specific *git* config

```bash
git config push.pushOption 'base=main'
```

Setting this in your *git* config may also be useful if
you're using an alternative *git* frontend, for example
[*Jujutsu*](https://jj-vcs.github.io/jj/latest/), which does not provide the
ability to set push-options when pushing to git remotes

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
