# CloudStack

1. Download the latest binary (replace version if a newer one exists)
   - wget https://github.com/apache/cloudstack-cloudmonkey/releases/download/6.4.0/cmk.linux.x86-64

2. Make it executable
   - chmod +x cmk.linux.x86-64

3. Move it to your local bin so you can just type 'cmk'
   - sudo mv cmk.linux.x86-64 /usr/local/bin/cmk

4. Verify installation
   - cmk version
   - ````plaintext
       zergaw@israel-vostro3520:~$ cmk version
       Loaded in-built API cache. Failed to read API cache, please run 'sync'.
       Apache CloudStack 🐵 CloudMonkey 6.4.0```
     ````

## Configuring CMK with these Keys

### How to Generate API and Secret Keys

`If you are logged in and don't see the keys, it usually means they haven't been "generated" for your user account yet.`

- `Navigate to Accounts:` On the left-hand sidebar menu, click on Accounts.

- `Select your Account:` Click on the name of the account you are currently logged into (often it matches your username).

- `View Users:` Within the account detail page, look for a tab or a button labeled `View Users.`
  - Note: In newer versions, there is often a Users tab directly at the top of the Account details screen.

- `Select your User:` Click on your specific username from the list.

- `Generate Keys:` \* Look at the top right for a "Generate Keys" icon (it usually looks like a small key or a circular refresh arrow).
  - If the keys are already there but hidden, look for a clipboard icon or an eye icon to reveal them.

  - Caution: If you click "Generate Keys" and you already had keys configured elsewhere (like in a script), the old ones will stop working immediately.

### Configuring CMK with these Keys

- Start cmk
  - `cmk`

  ```plaintext
    Loaded in-built API cache. Failed to read API cache, please run 'sync'.
    Apache CloudStack 🐵 CloudMonkey 6.4.0
    Report issues: https://github.com/apache/cloudstack-cloudmonkey/issues

    (localcloud) 🐱 >
  ```

- Set the values (replace with your actual data)
  - `(localcloud) 🐱 > set url https://cloudstack.zergaw.com/client/api`
    - Output might be: `Loaded in-built API cache. Failed to read API cache, please run 'sync'.`

  - `(localcloud) 🐱 > set apikey YOUR_GENERATED_API_KEY`
    - Output might be: `Loaded in-built API cache. Failed to read API cache, please run 'sync'.`

  - `(localcloud) 🐱 > set secretkey YOUR_GENERATED_SECRET_KEY`
    - Output might be: `Loaded in-built API cache. Failed to read API cache, please run 'sync'.`

- Save and sync
  - `sync`
    - Output might be:- `Discovered 393 APIs`

- Verify
  - `(localcloud) 🐱 > list zones`
  - `(localcloud) 🐱 > list virtualmachines`

- Some terminologies
  - cmk list serviceofferings
  - cmk list templates
  - cmk list zones
  - cmk list virtualmachines
  - cmk list publicipaddresses
