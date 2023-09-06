
package com.practice.sampleexample.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.practice.sampleexample.Model.User;
import com.practice.sampleexample.Model.VerificationCode;
import com.practice.sampleexample.Repository.EmailService;
import com.practice.sampleexample.Repository.UserRepository;
import com.practice.sampleexample.Repository.VerificationCodeRepo;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class UserService implements EmailService{

	@Autowired
	private UserRepository userRepo;

	@Autowired
	private JavaMailSender javaMailSender;

	@Autowired
	VerificationCodeRepo verificationCodeRepo;

	public UserService(UserRepository userRepo, JavaMailSender javaMailSender,
	VerificationCodeRepo verificationCodeRepo) {
		this.userRepo = userRepo;
		this.javaMailSender =javaMailSender;
		this.verificationCodeRepo = verificationCodeRepo;
	}

	public User addUser(User user) {
		System.out.println("hi from service");
		User u = userRepo.save(user);
		return u;
	}

	public boolean isEmailExists(String email) {
		System.out.println(email);
		return userRepo.existsByEmail(email);
	}

	public boolean validateLogin(String email, String password) {
		User user = userRepo.findByEmail(email);
		if (user != null && user.getPassword().equals(password)) {
			return true;
		}
		return false;
	}

	@Transactional
	@Override
	public void sendVerificationCode(String toEmail) {
		System.out.println("Email verification from service");
		int code = generateCode(); 
		MimeMessage message = javaMailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(message);
		String codeA = Integer.toString(code);
		verificationCodeRepo.deleteByEmail(toEmail);
		VerificationCode verificationCode = new VerificationCode();
		verificationCode.setEmail(toEmail);
		verificationCode.setCode(code);
		try {
			helper.setSubject("Verification code to Reset Password");
			helper.setText("Your verification code is :"+codeA);
			helper.setTo(toEmail);
		} catch (MessagingException e) {
			System.out.println(e.getMessage());
		}
		javaMailSender.send(message);
		verificationCodeRepo.save(verificationCode);
	}

	public int generateCode() {
		return (int) (Math.floor(100000 + Math.random() * 900000));
	}


	public boolean validateCodeFromDB(String email, String code) {

		System.out.println("Validate code from Service ");
		VerificationCode verificationCode = verificationCodeRepo.findByEmail(email);
		int codeF = Integer.parseInt(code);
		if(verificationCode!=null && verificationCode.getCode() == codeF){
			System.out.println("Success of verfication from service");
			return true;
		}
		else{
			return false;
		}
	}
}
