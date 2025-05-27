package model;

public class Imposto {
    private int idImposto;
    private String nome;
    private double percentual;
    private int status;

    public int getIdImposto() { return idImposto; }
    public void setIdImposto(int idImposto) { this.idImposto = idImposto; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public double getPercentual() { return percentual; }
    public void setPercentual(double percentual) { this.percentual = percentual; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
}
