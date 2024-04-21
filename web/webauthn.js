function base64URLToBuffer(base64URL) {
    const base64 = base64URL.replace(/-/g, '+').replace(/_/g, '/');
    const padLen = (4 - (base64.length % 4)) % 4;
    return Uint8Array.from(atob(base64.padEnd(base64.length + padLen, '=')), c => c.charCodeAt(0));
}

function bufferToBase64URL(buffer) {
    const uint8Array = new Uint8Array(buffer);
    return btoa(String.fromCharCode.apply(null, uint8Array));
}

function register(options, resolve, reject) {
    try {
        const jsOptions = {
            publicKey: {
                rp: {
                    id: options.publicKey.rp.id,
                    name: options.publicKey.rp.name
                },
                user: {
                    id: base64URLToBuffer(options.publicKey.user.id),
                    name: options.publicKey.user.name, // this is a username given by server, before even registration to passkeys.
                    displayName: options.publicKey.user.displayName // a display name given to passkey
                },
                challenge: base64URLToBuffer(options.publicKey.challenge),
                pubKeyCredParams: options.publicKey.pubKeyCredParams
            }
        };

        navigator.credentials.create(jsOptions)
            .then(function (credential) {
                if (credential !== null) {
                    const createResponse = {};

                    const response = credential.response;

                    // Access attestationObject ArrayBuffer
                    const attestationObj = bufferToBase64URL(response.attestationObject);

                    // Access client JSON
                    const clientJSON = bufferToBase64URL(response.clientDataJSON);

                    createResponse["attestation_object"] = attestationObj;
                    createResponse["client_data_json"] = clientJSON;
                    createResponse["credential_id"] = bufferToBase64URL(credential.rawId);

                    // created.
                    resolve(JSON.stringify(createResponse));
                } else {
                    console.log("response - passkey not supported.");
                    reject("passkey not supported");
                }
            })
            .catch(function (err) {
                console.error(err);
                reject(err.toString());
            });
    } catch (err) {
        console.error(err);
        reject(err.toString());
    }
}

function login(options, resolve, reject) {
    try {
        console.log(options);
        let allowedCreds = [];
        for (const i in options.publicKey.allowCredentials) {
            let allowedCred = options.publicKey.allowCredentials[i];
            console.log(allowedCred);
            allowedCreds.push({
                type: allowedCred.type,
                id: base64URLToBuffer(allowedCred.id)
            });
        }
        const publicKey = {
            challenge: base64URLToBuffer(options.publicKey.challenge),
            rpId: options.publicKey.rpId,
            allowCredentials: allowedCreds,
            userVerification: options.publicKey.userVerification,
        }
        navigator.credentials.get({publicKey}).then((publicKeyCredential) => {
            const response = publicKeyCredential.response;

            // Access authenticator data ArrayBuffer
            const authenticatorData = response.authenticatorData;

            // Access client JSON
            const clientJSON = response.clientDataJSON;

            // Access signature ArrayBuffer
            const signature = response.signature;

            // Access userHandle ArrayBuffer
            const userHandle = response.userHandle;

            const loginResponse = {};
            loginResponse["auth_data"] = bufferToBase64URL(authenticatorData);
            loginResponse["client_data_json"] = bufferToBase64URL(clientJSON);
            loginResponse["signature"] = bufferToBase64URL(signature);
            loginResponse["user_handle"] = bufferToBase64URL(userHandle);
            resolve(JSON.stringify(loginResponse));
        }).catch(function (err) {
            console.error(err);
            reject(err.toString());
        });
    } catch (err) {
        console.error(err);
        reject(err.toString());
    }
}
