package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ContraChequeDAO extends DataBaseDAO {

    public ContraChequeDAO() throws Exception {
    }

    public List<ContraCheque> getLista() throws SQLException {
        List<ContraCheque> lista = new ArrayList<>();
        String SQL = "SELECT * FROM contra_cheque";
        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(SQL);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                ContraCheque c = new ContraCheque();
                c.setIdContraCheque(rs.getInt("idContra_cheque"));
                c.setValorBruto(rs.getBigDecimal("valorBruto"));
                c.setDescontos(rs.getBigDecimal("descontos"));
                c.setValorLiquido(rs.getBigDecimal("valorLiquido"));
                c.setFuncionarioId(rs.getInt("funcionario_idFfuncionario"));
                lista.add(c);
            }
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar contra-cheques: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public boolean gravar(ContraCheque c) {
        try {
            this.conectar();
            String sql;
            PreparedStatement pstm;

            if (c.getIdContraCheque() == 0) {
                sql = "INSERT INTO contra_cheque (valorBruto, descontos, valorLiquido, funcionario_idFfuncionario) VALUES (?, ?, ?, ?)";
                pstm = conn.prepareStatement(sql);
                pstm.setBigDecimal(1, c.getValorBruto());
                pstm.setBigDecimal(2, c.getDescontos());
                pstm.setBigDecimal(3, c.getValorLiquido());
                pstm.setInt(4, c.getFuncionarioId());
            } else {
                sql = "UPDATE contra_cheque SET valorBruto=?, descontos=?, valorLiquido=?, funcionario_idFfuncionario=? WHERE idContra_cheque=?";
                pstm = conn.prepareStatement(sql);
                pstm.setBigDecimal(1, c.getValorBruto());
                pstm.setBigDecimal(2, c.getDescontos());
                pstm.setBigDecimal(3, c.getValorLiquido());
                pstm.setInt(4, c.getFuncionarioId());
                pstm.setInt(5, c.getIdContraCheque());
            }

            pstm.execute();
            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao gravar: " + e);
            return false;
        }
    }

    public ContraCheque getCarregaPorID(int idContraCheque) throws Exception {
        ContraCheque c = new ContraCheque();
        String sql = "SELECT * FROM contra_cheque WHERE idContra_cheque=?";
        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idContraCheque);
        ResultSet rs = pstm.executeQuery();

        if (rs.next()) {
            c.setIdContraCheque(rs.getInt("idContra_cheque"));
            c.setValorBruto(rs.getBigDecimal("valorBruto"));
            c.setDescontos(rs.getBigDecimal("descontos"));
            c.setValorLiquido(rs.getBigDecimal("valorLiquido"));
            c.setFuncionarioId(rs.getInt("funcionario_idFfuncionario"));
        }

        this.desconectar();
        return c;
    }

    public boolean excluir(ContraCheque c) {
        try {
            this.conectar();
            String sql = "DELETE FROM contra_cheque WHERE idContra_cheque=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, c.getIdContraCheque());
            pstm.execute();
            this.desconectar();
            return true;
        } catch (SQLException e) {
            System.out.println("Erro ao excluir: " + e);
            return false;
        }
    }
    
    //Barra de busca
    public List<ContraCheque> buscarPorTermo(String termo) throws Exception {
    List<ContraCheque> lista = new ArrayList<>();

    String sql = "SELECT * FROM contra_cheque WHERE " +
                 "CAST(idContra_cheque AS CHAR) LIKE ? OR " +
                 "CAST(valorBruto AS CHAR) LIKE ? OR " +
                 "CAST(descontos AS CHAR) LIKE ? OR " +
                 "CAST(valorLiquido AS CHAR) LIKE ? OR " +
                 "CAST(funcionario_idFfuncionario AS CHAR) LIKE ?";

    this.conectar();
    try (PreparedStatement pstm = conn.prepareStatement(sql)) {
        String filtro = "%" + termo + "%";
        for (int i = 1; i <= 5; i++) {
            pstm.setString(i, filtro);
        }

        ResultSet rs = pstm.executeQuery();
        while (rs.next()) {
            ContraCheque c = new ContraCheque();
            c.setIdContraCheque(rs.getInt("idContra_cheque"));
            c.setValorBruto(rs.getBigDecimal("valorBruto"));
            c.setDescontos(rs.getBigDecimal("descontos"));
            c.setValorLiquido(rs.getBigDecimal("valorLiquido"));
            c.setFuncionarioId(rs.getInt("funcionario_idFfuncionario"));
            lista.add(c);
        }
    } finally {
        this.desconectar();
    }

    return lista;
}


}
