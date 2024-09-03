# hestia-nodeJS

A simple (for me, at least) way to run NodeJS reliably through HestiaCP.

Supports multiple users/domains, each running on its own Unix Domain Socket.

This project is based on [JLFdzDev's hestiacp-nodejs](https://github.com/JLFdzDev/hestiacp-nodejs) idea.

## Installation
First, login to server shell with a user with sudo permission (or run as root).

1. Clone git repository
```
git clone https://github.com/alissonyagi/hestia-nodeJS.git
```
2. Adjust install script permission
```
chmod 755 hestia-nodeJS/install.sh
```
3. Run installer
```
sudo hestia-nodeJS/install.sh
```

## How to use

1. On HestiaCP, enable bash login to the user who owns the domain.
  - Edit user
  - Advanced Options
  - Change ***SSH Access*** to **bash**.

2. Login to server shell using the user above.

> [!NOTE]
> If you already have nvm (or node) and pm2 installed, jump to step 5.

3. Install nvm (check [installation guide](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating))
4. Install pm2
```
npm install -g pm2
```

5. Create a web domain using HestiaCP.
6. Upload your app to `~/web/[your-domain-here]/private/node` (whatever method you prefer).
7. On HestiaCP
  - Edit the web domain created on step 5
  - Advanced Options
  - Change **Proxy Template** to **nodeJS**.
  - Save

## Troubleshoot
1. Login to server shell
2. Check pm2
  ```
  pm2 status
  ```
  - If it does not list your domain, review the *How to use* section above (just in case, you know).
  - If it lists with an **error** status, check the logs:

    ```
    pm2 logs
    ```
4. Still not listed? Try to start manually
  ```
  pm2 start ~/web/[your-domain-here]/private/hestia-nodeJS/ecosystem.config.js
  ```
5. Check the output of the command above and if everything seems to be fine, check again (step 2) to make sure.

> [!IMPORTANT]
> hestia-nodeJS tries to auto-configure `ecosystem.config.js`.
If something goes wrong with that or if you need specific options, you can customize it (mainly `cwd` and `script`).
```
Location: ~/web/[your-domain-here]/private/hestia-nodeJS/ecosystem.config.js
```


## Uninstall
Login to server shell as explained in Install section.

1. Clone git repository (you can bypass this step if you still have the directory)
```
git clone https://github.com/alissonyagi/hestia-nodeJS.git
```
2. Adjust uninstall script permission
```
chmod 755 hestia-nodeJS/uninstall.sh
```
3. Run uninstaller
```
sudo hestia-nodeJS/uninstall.sh
```
