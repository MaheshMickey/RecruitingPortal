<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Signup Page</title>
        <link rel="stylesheet" type="text/css" href="/css/signup.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    </head>
    <script>
        function checkEmail() {
            var emailInput = document.getElementById("email");
            var emailStatus = document.getElementById("emailStatus");

            var email = emailInput.value;

            // Make an AJAX request to the server
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "/checkEmail?email=" + email, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        var response = JSON.parse(xhr.responseText);
                        if (response.exists) {
                            // Email already exists
                            emailStatus.textContent = "Email Id already exists  ";
                            emailStatus.style.color = "red";
                            emailStatus.innerHTML =   "<i class='fas fa-times-circle' style='font-size:15px;color:red'></i>   " + emailStatus.textContent;
                            document.getElementById("password").disabled = true;
                            document.getElementById("confirmPassword").disabled = true;
                            document.getElementById('submit').disabled = true;
                            document.getElementById('submit').style.backgroundColor = "grey";
                        } else {    
                            // Email is available
                            emailStatus.textContent = "New User  ";
                            emailStatus.style.color = "green";
                            emailStatus.innerHTML =  emailStatus.textContent + "<i class='fas fa-check-circle'></i>";
                            document.getElementById("password").disabled = false;
                            document.getElementById("confirmPassword").disabled = false;
                            document.getElementById('submit').disabled = false;
                        }
                    } else {
                        // Error occurred
                        emailStatus.textContent = "Error checking email";
                    }
                }
            };
            xhr.send();
        }       

        function validatePassword(){
            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            var passwordStatus = document.getElementById('passwordMatch');

            if(password != confirmPassword){
                passwordStatus.textContent = "Passwords doesn't match";
                passwordStatus.innerHTML = passwordStatus.textContent  + "<i class='fas fa-times-circle' style='font-size:15px;color:red'></i>";
                passwordStatus.style.display = "block";
                document.getElementById('submit').disabled = true;
                document.getElementById('submit').style.backgroundColor = "grey";
                
            }
            else{
                passwordStatus.textContent = "Passwords Match";
                passwordStatus.style.color = "green";
                passwordStatus.innerHTML = passwordStatus.textContent  + "<i class='fas fa-check-circle' style='font-size:15px;color:green'></i>";
                passwordStatus.style.display = "block";
                document.getElementById('submit').disabled = false;
                document.getElementById('submit').style.backgroundColor = "#4caf50";
            }
        
        }
        
        function validatePasswordPattern(){
                var password = document.getElementById('password').value;
                var passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

                if(!passwordPattern.test(password)){
                    document.getElementById('passwordPattern').textContent = "Password must contain atleast ONE UPPERCASE, ONE LOWERCASE, ONE DIGIT, ONE SPECIALCHARACTER, and length of 8";
                    document.getElementById('passwordPattern').style.display = "block";
                    document.getElementById('passwordPattern').style.color = "red";
                    document.getElementById('submit').disabled = true;
                    document.getElementById('submit').style.backgroundColor = "grey";
                }
                else{
                    document.getElementById('passwordPattern').textContent = "Password meets the criteria";
                    document.getElementById('passwordPattern').style.color = "green";
                    document.getElementById('passwordPattern').style.display = "block";
                    document.getElementById('passwordPattern').innerHTML = document.getElementById('passwordPattern').textContent+
                    "<i class='fas fa-check-circle' style='font-size:15px;color:green'></i>";
                    document.getElementById('submit').disabled = false;
                    document.getElementById('submit').style.backgroundColor = "#4caf50";
                    
                }
            }
    
    </script>

    <body>
                  <div class="form-container">
               <h2>Signup</h2>
               <form id="myForm" action="signup" method="post">
                   <label for="firstName">First Name:</label>
                   <input type="text" id="firstName" name="firstName" required>
                   <br>
                   <label for="lastName">Last Name:</label>
                   <input type="text" id="lastName" name="lastName" required>
                   <br>
                   <label for="email">Email:</label>
                   <input type="email" id="email" name="email" onkeyup="checkEmail()" required>
                   <p id="emailStatus"></p>
                   <label for="password">Password:</label>
                   <input type="password" id="password" name="password" onkeyup="validatePasswordPattern()" required>
                   <p id="passwordPattern">Password must contain atleast ONE UPPERCASE, ONE LOWERCASE, ONE DIGIT, ONE SPECIALCHARACTER, and length of 8</p>
                   <br>
                   <label for="confirmPassword">Confirm Password:</label>
                   <input type="password" id="confirmPassword" name="confirmPassword" onkeyup="validatePassword()" required>
                   <p id="passwordMatch" style="display: none; color: red;"></p>
                   <br>
                   <button id="submit" type="submit" value="Sign Up">Sign up</button>
               </form>
               <p><a href="home.jsp">Back to login?</p>
           </div>

    </body>

    </html>