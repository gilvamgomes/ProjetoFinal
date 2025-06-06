package model;

public class Menu {

    private int idMenu;
    private String nome;
    private String link;
    private String icone;
    private int exibir;

    public Menu() {
    }

    public Menu(int idMenu, String nome, String link, String icone, int exibir) {
        this.idMenu = idMenu;
        this.nome = nome;
        this.link = link;
        this.icone = icone;
        this.exibir = exibir;
    }

    public int getIdMenu() {
        return idMenu;
    }

    public void setIdMenu(int idMenu) {
        this.idMenu = idMenu;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getIcone() {
        return icone;
    }

    public void setIcone(String icone) {
        this.icone = icone;
    }

    public int getExibir() {
        return exibir;
    }

    public void setExibir(int exibir) {
        this.exibir = exibir;
    }

    @Override
    public String toString() {
        return "Menu{" + "nome=" + nome + '}';
    }
}