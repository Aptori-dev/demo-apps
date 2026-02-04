# crAPI Security Testing with Aptori

## Introduction

[crAPI](https://github.com/OWASP/crAPI) is an intentionally vulnerable API
designed to demonstrate security weaknesses from the **OWASP API Security Top
10**. This repository includes scripts and configurations to deploy **crAPI**
and analyze it using **Aptori Sift** for security testing.

## Setup and Deployment

### Launching crAPI
This repository provides configuration for using **Docker Compose** to run
crAPI.  A modified copy of `docker-compose.yaml` and required `keys` from the
crAPI project are included.

To deploy crAPI, follow these steps:

1. **Run the launch script**  

   ```sh
   ./launch.sh
   ```

   The script will:
   - Pull container images
   - Start the service containers
   - Create user accounts
   - Restart the services to ensure database initialization
   - Verify API functionality

2. **Set the Container Engine (Optional)**  
   The script defaults to `docker`, but you can modify the `CE` variable in `launch.sh` to use **nerdctl** (recommended for Rancher Desktop users).

### **Stopping and Cleaning Up**

To stop and remove all crAPI-related containers and volumes, run:

```sh
./destroy.sh
```
**⚠ WARNING:** If using Docker, `destroy.sh` may remove volumes from other containers. Review the script before executing it to prevent accidental data loss.

---

## Initializing Data

The `launch.sh` script creates user accounts and sends **email confirmations** (including VIN and PIN codes) to a **Mailhog** service.

To retrieve the email:

1. Open **Mailhog** in your browser:
   ```
   http://localhost:8025
   ```
2. Locate the email with the VIN and PIN for the respective user.

### Adding Vehicles to User Accounts

#### Alice's Account
Replace `{{ALICE_VIN}}` and `{{ALICE_PINCODE}}` with values from Mailhog.

```sh
curl -X POST "http://localhost:8888/identity/api/v2/vehicle/add_vehicle" \
    -H "Authorization: $(./login-alice.sh)" \
    -H "Content-Type: application/json" \
    -d '{"vin": "{{ALICE_VIN}}", "pincode": "{{ALICE_PINCODE}}"}'
```

#### Bob's Account
Replace `{{BOB_VIN}}` and `{{BOB_PINCODE}}` with values from Mailhog.

```sh
curl -X POST "http://localhost:8888/identity/api/v2/vehicle/add_vehicle" \
    -H "Authorization: $(./login-bob.sh)" \
    -H "Content-Type: application/json" \
    -d '{"vin": "{{BOB_VIN}}", "pincode": "{{BOB_PINCODE}}"}'
```

---

## Security Testing with Aptori Sift

### Adding crAPI as an API Asset in Aptori
1. Navigate to **Aptori Platform** → **Projects** → **Add API**.
2. Add a new API asset for **crAPI**.
3. Upload the **`openapi.json`** file from this directory.
4. Copy the **Asset ID** generated for use in the next step.

### Running Aptori Sift
Run the following command, replacing `{{assetID}}` with the actual Asset ID:

```sh
sift run --config sift-crapi.yaml --target-id {{assetID}}
```

---

## Appendix

### File Attribution
The following files are sourced from the [crAPI Project](https://github.com/OWASP/crAPI)
under the **Apache 2.0** license:

- `openapi.json`
- `docker-compose.yaml`
- `keys/jwks.json`

---

### **Final Notes**
- This setup is meant for **security testing and research purposes** only.
- If you encounter issues, refer to [crAPI’s official documentation](https://github.com/OWASP/crAPI/blob/develop/docs/setup.md).
- **Aptori Sift** helps analyze and identify API vulnerabilities based on the OWASP API Security Top 10.

