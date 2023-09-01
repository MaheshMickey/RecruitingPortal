<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="ISO-8859-1">
        <link rel="stylesheet" type="text/css" href="/css/home.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <title>Login Page</title>
     
    </head>
    <script>
        function validateLoginEmail(){
            var email = document.getElementById('email').value;
            var statusIcon = document.getElementById('checkEmailStatus');
            
            if(email.trim() !=''){
                statusIcon.style.display='inline-block';
            }
            else{
                statusIcon.style.display = 'none';
            }
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "/checkLoginEmail?email=" + email, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE){
                    if(xhr.status == 200){
                        var response = JSON.parse(xhr.responseText);
                        if(response.exists){
                            statusIcon.innerHTML = "<i class='fa fa-check' style='font-size:15px;color:green'></i>";
                            document.getElementById('loginButton').disabled = false;
                            document.getElementById('password').disabled = false;

                        }
                        else if(!response.exists){
                            statusIcon.innerHTML = "<i class='fa fa-times' style='font-size:15px;color:red'></i>";
                            document.getElementById('loginButton').disabled = true;
                            document.getElementById('password').disabled = true;

                        }

                    }
                }
            };
            xhr.send();
        }
    </script>
   
    <body>
        <div class="form-container">
            <h3>Login Here</h3>
            <form  id="loginForm" action="login" method="post">
                <label for="username">Username:</label>
                <div class="input-with-icon" id="emailInput">
                    <input type="text" id="email" name="email" onkeyup="validateLoginEmail()" required>
                    <span class="input-icon" id="checkEmailStatus">
                    </span>
                </div>
                <br>
                <label for="password">Password:</label>
                <div class="input-with-icon" id="passwordInput">
                    <input type="password" id="password" name="password" required>
                    <span class="input-icon" id="checkPasswordStatus">
                    </span>
                </div> 
                <br>
                <button id="loginButton" type="submit">Log In</button>
                <br>
                <p>
                    <a href="forgotpassword.jsp" class="moreLinks"> Forgot your password? </a><br><br>
                    <a href="signup.jsp" class="moreLinks"> New user? Register Here!! </a>
                </p>
                <p id="errorMessage"></p>
            </form>
        </div>
    </body>
</html>