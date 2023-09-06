<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                        Please check the code sent to the above email.
                    </div>
                </div>
                <div id="codeSubmitContainer" style="text-align: center; margin-top: 10px;">
                    <button id="codeSubmit" type="submit">Validate Code</button>
                    <div id="timer-container">
                        <span id="timer">00:30</span>
                    </div>
                </div>
            </form>
            <button id="resendCode" type="submit" style="display: none;" type="button">Resend Code</button>
        </div>
    </body>

    <script>
        var intervalId;

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

                var xhr = new XMLHttpRequest();
                var url = "/code?email=" + encodeURIComponent(email);

                xhr.open("POST", url, true);
                xhr.setRequestHeader("Content-Type", "application/json");

                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            var data = JSON.parse(xhr.responseText);
                            console.log(data);
                        } else {
                            console.error("Request Failed");
                        }
                    }
                };

                xhr.send(JSON.stringify(requestBody));

                var codeForm = document.getElementById("codeForm");
                var submitContainer = document.getElementById("submit-container");
                submitContainer.insertAdjacentElement("afterend", codeForm);

                var timerDisplay = document.getElementById("timer");
                startTimer(30, timerDisplay);
            });

            document.getElementById("codeForm").addEventListener("submit", function (event) {
                event.preventDefault();

                var code = document.getElementById("codeInput").value;
                var email = document.getElementById("email").value;
                document.getElementById("codeForm").reset();
                //document.getElementById("codeSubmit").disabled = true;
                var timerDisplay = document.getElementById("timer");
                clearInterval(intervalId);
                startTimer(30, timerDisplay);

                var requestS = {
                    email: email,
                    code: code
                };


                var xhr = new XMLHttpRequest();
                var url = "/validatecode?email=" + encodeURIComponent(email) + "&code=" + encodeURIComponent(code);

                xhr.open("POST", url, true);
                xhr.setRequestHeader("Content-Type", "application/json");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                           window.location.href = "http://localhost:8080/setpassword.jsp";
                            //console.log(data);
                            //document.getElementById("codeSubmit").disabled = false;
                        } else {
                            console.error("Request Failed");
                            document.getElementById("codeSubmit").disabled = false;
                        }
                    }
                };

                xhr.send(JSON.stringify(requestS));
            });
            document.getElementById("resendCode").addEventListener("click", function () {
                document.getElementById("resendCode").style.display = "none";

                var timerDisplay = document.getElementById("timer");
                startTimer(30, timerDisplay);
                var event = new Event("submit", {
                    bubbles: true,
                    cancelable: true,
                });
                document.getElementById("forgotPasswordForm").dispatchEvent(event);
                var timerDisplay = document.getElementById("timer");
                startTimer(30, timerDisplay);
            });
        });

        function startTimer(duration, display) {
            var timer = duration, minutes, seconds;
            intervalId = setInterval(function () {
                minutes = parseInt(timer / 60, 10);
                seconds = parseInt(timer % 60, 10);

                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;

                display.textContent = minutes + ":" + seconds;

                if (--timer < 0) {
                    clearInterval(intervalId);
                    display.textContent = "00:00";
                    document.getElementById("resendCode").style.display = "block";
                }
            }, 1000);
        }
    </script>


    </html>