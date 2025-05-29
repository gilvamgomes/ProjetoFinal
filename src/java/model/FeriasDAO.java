package model;

import java.sql.*;
import java.util.*;

public class FeriasDAO extends DataBaseDAO {

    public boolean gravar(Ferias f) {
        try {
            this.conectar();
            String sql;
            if (f.getIdFerias() == 0) {
                sql = "INSERT INTO ferias (dataInicio, dataFim, status, funcionario_idFfuncionario) VALUES (?, ?, ?, ?)";
            } else {
                sql = "UPDATE ferias SET dataInicio=?, dataFim=?, status=?, funcionario_idFfuncionario=? WHERE idFerias=?";
            }

            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setDate(1, new java.sql.Date(f.getDataInicio().getTime()));
            pstm.setDate(2, new java.sql.Date(f.getDataFim().getTime()));
            pstm.setString(3, f.getStatus());
            pstm.setInt(4, f.getFuncionario_idFfuncionario());
            if (f.getIdFerias() != 0) {
                pstm.setInt(5, f.getIdFerias());
            }

            pstm.execute();
            this.desconectar();
            return true;
        } catch (Exception e) {
            System.out.println("Erro ao gravar férias: " + e.getMessage());
            return false;
        }
    }

    public List<Ferias> getLista() {
        List<Ferias> lista = new ArrayList<>();
        try {
            this.conectar();
            String sql = "SELECT * FROM ferias";
            PreparedStatement pstm = conn.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                Ferias f = new Ferias();
                f.setIdFerias(rs.getInt("idFerias"));
                f.setDataInicio(rs.getDate("dataInicio"));
                f.setDataFim(rs.getDate("dataFim"));
                f.setStatus(rs.getString("status"));
                f.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));
                lista.add(f);
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao listar férias: " + e.getMessage());
        }
        return lista;
    }

    public Ferias getCarregaPorID(int idFerias) {
        Ferias f = new Ferias();
        try {
            this.conectar();
            String sql = "SELECT * FROM ferias WHERE idFerias=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, idFerias);
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                f.setIdFerias(rs.getInt("idFerias"));
                f.setDataInicio(rs.getDate("dataInicio"));
                f.setDataFim(rs.getDate("dataFim"));
                f.setStatus(rs.getString("status"));
                f.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao carregar férias: " + e.getMessage());
        }
        return f;
    }

    public boolean excluir(int idFerias) {
        try {
            this.conectar();
            String sql = "DELETE FROM ferias WHERE idFerias=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, idFerias);
            pstm.execute();
            this.desconectar();
            return true;
        } catch (Exception e) {
            System.out.println("Erro ao excluir férias: " + e.getMessage());
            return false;
        }
    }
}
