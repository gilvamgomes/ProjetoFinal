package model;

import java.util.ArrayList;

public class Perfil {

    private int idPerfil;
    private String nome;
    private int status;
    private ArrayList<Menu> menus;
    private ArrayList<Menu> naoMenus;

    public Perfil() {
    }

    public Perfil(int idPerfil, String nome, int status) {
        this.idPerfil = idPerfil;
        this.nome = nome;
        this.status = status;
    }

    public int getIdPerfil() {
        return idPerfil;
    }

    public void setIdPerfil(int idPerfil) {
        this.idPerfil = idPerfil;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public ArrayList<Menu> getMenus() {
        return menus;
    }

    public void setMenus(ArrayList<Menu> menus) {
        this.menus = menus;
    }

    public ArrayList<Menu> getNaoMenus() {
        return naoMenus;
    }

    public void setNaoMenus(ArrayList<Menu> naoMenus) {
        this.naoMenus = naoMenus;
    }

    @Override
    public String toString() {
        return "Perfil{" + "nome=" + nome + '}';
    }
    
}