<%@ page contentType="text/html; charset=UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Forgot Password</title>
        <link rel="stylesheet" type="text/css" href="/css/forgotpassword.css">
    </head>

    <body>
        <div class="form-container">
            <h1>Forgot Password</h1>
            <form id="forgotPasswordForm" method="post">
                <input type="email" id="email" name="email" placeholder="Enter your email address" required>
                <div id="submit-container">
                    <button id="submit" type="submit">Send Code</button>
                </div>
            </form>

            <form id="codeForm" style="display: none;">
                <div class="input-container">
                    <input type="text" id="codeInput" name="code" placeholder="Enter the code" required>
                    <div class="info-icon"></div>
                    <div class="info-tooltip">
                        Please check the code sent to above email.
                    </div>
                </div>
                <div id="codeSubmitContainer" style="text-align: center; margin-top: 10px;">
                    <button id="codeSubmit" type="submit">Validate Code</button>
                </div>
            </form>
        </div>
    </body>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("forgotPasswordForm").addEventListener("submit", function (event) {
                event.preventDefault();

                var email = document.getElementById("email").value;
                document.getElementById("email").readOnly = true;
                document.getElementById("submit").hidden = true;
                document.getElementById("codeForm").style.display = "block";

                var requestBody = {
                    email: email
                };

                var url = "/oauth2/code?email=" + encodeURIComponent(email);
                fetch(url, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(requestBody)
                })
                    .then(response => {
                        if (response.ok) {
                            return response.json();
                        }
                        else {
                            throw new Error("Request Failed");
                        }
                    })
                    .then(data => {
                        console.log(data);
                    })
                    .catch(error => {
                        console.error(error);
                    });

                var codeForm = document.getElementById("codeForm");
                var submitContainer = document.getElementById("submit-container");
                submitContainer.insertAdjacentElement("afterend", codeForm);
            });

            document.getElementById("codeForm").addEventListener("submit", function (event) {
                event.preventDefault();

                var code = document.getElementById("codeInput").value;
                document.getElementById("codeForm").reset();

                var requestS = {
                    code: code
                };
                fetch(
                    "/validate-code", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(requestS)
                })
                    .then(response => {
                        if (response.ok) {
                            return response.json();
                        }
                        else {
                            throw new Error("Request Failed");
                        }
                    })
                    .then(data => {
                        console.log(data);
                    })
                    .catch(error => {
                        console.error(error);
                    });
            });
        });
    </script>

    </html>