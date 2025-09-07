# Welcome to the Patisserie

*~ your one-stop-cake-shop for everything Freshly Baked has to offer*

## Structure

Patisserie is a [monorepo](https://en.wikipedia.org/wiki/Monorepo), which means
there are multiple projects hosted here. Here's a list!

| Project   | Description                                                          |
| --------- | -------------------------------------------------------------------- |
| packetmix | Our NixOS configurations ("All you need to bake a delicious system") |

## Cloning a single project

You may clone and push to patisserie via tangled as you usually would. If you'd
like to clone only a single project, however, we provide a public
[josh proxy](https://josh-project.github.io/josh/) which can be used to filter your
clone:

```bash
git clone https://git.freshlybakedca.ke/patisserie.git:/packetmix.git
# Swap out "packetmix" at the end of the URL for whatever project you want to clone
```

If you need to push then, as with tangled normally, you are required to use SSH.

Josh can push via SSH, but requires you to forward your SSH agent to
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
Pushing will work as normal for SSH clones.

```bash
git clone ssh://git@git.freshlybakedca.ke/patisserie.git:/packetmix.git
# Swap out "packetmix" at the end of the URL for whatever project you want to clone
```
