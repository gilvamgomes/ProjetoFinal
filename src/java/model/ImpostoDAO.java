package model;

import java.sql.*;
import java.util.*;

public class ImpostoDAO extends DataBaseDAO {

    public ImpostoDAO() throws Exception {}

    public boolean gravar(Imposto i) {
        try {
            this.conectar();
            String sql;
            if (i.getIdImposto() == 0) {
                sql = "INSERT INTO imposto (nome, percentual, status) VALUES (?, ?, ?)";
            } else {
                sql = "UPDATE imposto SET nome=?, percentual=?, status=? WHERE idImposto=?";
            }
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setString(1, i.getNome());
            pstm.setDouble(2, i.getPercentual());
            pstm.setInt(3, i.getStatus());
            if (i.getIdImposto() != 0) {
                pstm.setInt(4, i.getIdImposto());
            }
            pstm.execute();
            this.desconectar();
            return true;
        } catch (Exception e) {
            System.out.println("Erro ao gravar imposto: " + e.getMessage());
            return false;
        }
    }

    public List<Imposto> getLista() {
        List<Imposto> lista = new ArrayList<>();
        try {
            this.conectar();
            String sql = "SELECT * FROM imposto";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                Imposto i = new Imposto();
                i.setIdImposto(rs.getInt("idImposto"));
                i.setNome(rs.getString("nome"));
                i.setPercentual(rs.getDouble("percentual"));
                i.setStatus(rs.getInt("status"));
                lista.add(i);
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao listar imposto: " + e.getMessage());
        }
        return lista;
    }

    public boolean excluir(int idImposto) {
        try {
            this.conectar();
            String sql = "DELETE FROM imposto WHERE idImposto=?";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setInt(1, idImposto);
            pstm.execute();
            this.desconectar();
            return true;
        } catch (Exception e) {
            System.out.println("Erro ao excluir imposto: " + e.getMessage());
            return false;
        }
    }

    public Imposto getCarregaPorID(int idImposto) {
        Imposto i = new Imposto();
        try {
            this.conectar();
            String sql = "SELECT * FROM imposto WHERE idImposto=?";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setInt(1, idImposto);
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                i.setIdImposto(rs.getInt("idImposto"));
                i.setNome(rs.getString("nome"));
                i.setPercentual(rs.getDouble("percentual"));
                i.setStatus(rs.getInt("status"));
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao carregar imposto: " + e.getMessage());
        }
        return i;
    }
}
