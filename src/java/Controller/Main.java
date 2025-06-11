/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author thien
 */
public class Main {

    public static void main(String[] args) {
        String hashed = "$2a$12$TSDFrHdEsG56OuqNXuQpWeZEG7yOoBWHeizccaBWI06Av84IHM1/W";
        String pass = "hashed_pass10";
        System.out.println(BCrypt.hashpw(pass, BCrypt.gensalt(12)));
        
    }
}
