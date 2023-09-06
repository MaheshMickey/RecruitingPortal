package com.practice.sampleexample.Controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.practice.sampleexample.Model.User;
import com.practice.sampleexample.Service.UserService;

import jakarta.mail.MessagingException;

@RestController
public class UserController {

	@Autowired
	private UserService userService;

	public UserController(UserService userService) {
		this.userService = userService;
	}

	@GetMapping("/")
	public ModelAndView home() {
		ModelAndView mv = new ModelAndView();
		System.out.println("get");
		mv.setViewName("home.jsp");
		return mv;
	}

	@GetMapping(value = {"/checkEmail","/checkLoginEmail"})
	public ResponseEntity<?> checkEmailExists(@RequestParam String email) {
		boolean exists = userService.isEmailExists(email);
		Map<String, Boolean> response = new HashMap<>();
		response.put("exists", exists);
		return ResponseEntity.ok(response);
	}

	@PostMapping("/signup")
	public ModelAndView addUser(User user, Model m) {
		System.out.println("Post");
		ModelAndView mv = new ModelAndView();
		userService.addUser(user);
		mv.addObject("emailExists", user);
		mv.setViewName("home.jsp");
		return mv;
	}

	@PostMapping("/login")
	public ModelAndView login(@RequestParam("email") String email, @RequestParam("password") String password){
		ModelAndView mv = new ModelAndView();
		if(userService.validateLogin(email, password)){
			System.out.println("Login Success");
			mv.setViewName("dashboard.jsp");
			return mv;
		}
		else{
			System.out.println("Not a valid login");
			mv.setViewName("home.jsp");
			return mv;
		}
	}

    // @PostMapping("/sendverificationcode")
	// public ModelAndView sendVerification(@RequestParam("email") String email){
	// 	System.out.println("Email verification from controller");
	// 	ModelAndView mv = new ModelAndView();
	// 	userService.sendVerificationCode(email);
	// 	mv.setViewName("forgotpassword.jsp");
	// 	return mv;
	// }

	// MimeMessage message = emailService.createMimeMessage();
		// MimeMessageHelper helper = new MimeMessageHelper(message);
		// helper.setSubject("Verification code to Reset Password");
		// helper.setText("Your verification code is :");
		// helper.setTo(Email);
		// emailService.send(message);

	@PostMapping("/code")
	public ModelAndView sendEmail(@RequestParam("email") String Email) throws MessagingException, UnsupportedEncodingException{
		ModelAndView mv =  new ModelAndView();
		System.out.println("From Controller");
		userService.sendVerificationCode(Email);
		mv.setViewName("setpassword.jsp");
		return mv;
	}

	@PostMapping("/validatecode")
	public ModelAndView validateCodeFromDB(@RequestParam("email")String email, @RequestParam("code") String code){
		 System.out.println("Validate Code from Controller");
		ModelAndView mv = new ModelAndView();
		if(userService.validateCodeFromDB(email, code)){
			System.out.println("Code validation inside controller");
		mv.setViewName("setpassword.jsp");
		}
		return mv;
	}
}
