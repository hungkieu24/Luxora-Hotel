/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author hungk
 */
public class HotelBranch {
    private int id;
    private String name;
    private String address;
    private String phone;
    private String email;
    private String image_url;
    private String owner_id;
    private String manager_id;
    private UserAccount owner;
    private UserAccount manager;

    public HotelBranch() {
    }

    public HotelBranch(int id, String name, String address, String phone, String email, String image_url, String owner_id, String manager_id) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.image_url = image_url;
        this.owner_id = owner_id;
        this.manager_id = manager_id;
    }

    public HotelBranch(int id, String name, String address, String phone, String email, String image_url, UserAccount owner, UserAccount manager) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.image_url = image_url;
        this.owner = owner;
        this.manager = manager;
    }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getOwner_id() {
        return owner_id;
    }

    public void setOwner_id(String owner_id) {
        this.owner_id = owner_id;
    }

    public String getManager_id() {
        return manager_id;
    }

    public void setManager_id(String manager_id) {
        this.manager_id = manager_id;
    }

    public UserAccount getOwner() {
        return owner;
    }

    public void setOwner(UserAccount owner) {
        this.owner = owner;
    }

    public UserAccount getManager() {
        return manager;
    }

    public void setManager(UserAccount manager) {
        this.manager = manager;
    }

    @Override
    public String toString() {
        return "HotelBranch{" + "id=" + id + ", name=" + name + ", address=" + address + ", phone=" + phone + ", email=" + email + ", image_url=" + image_url + ", owner_id=" + owner_id + ", manager_id=" + manager_id + '}';
    }
}
