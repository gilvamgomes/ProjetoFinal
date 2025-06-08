package model;

import java.sql.*;
import java.util.*;

public class PagamentoDAO extends DataBaseDAO {

    public PagamentoDAO() throws Exception {}

    public boolean gravar(Pagamento p) {
        try {
            this.conectar();
            String sql;

            if (p.getIdPagamento() == 0) {
                sql = "INSERT INTO pagamento (tipoPagamento, valor, dataPagamento, funcionario_idFfuncionario) VALUES (?, ?, ?, ?)";
            } else {
                sql = "UPDATE pagamento SET tipoPagamento=?, valor=?, dataPagamento=?, funcionario_idFfuncionario=? WHERE idPagamento=?";
            }

            PreparedStatement pstm = this.conn.prepareStatement(sql);

            pstm.setString(1, p.getTipoPagamento());
            pstm.setDouble(2, p.getValor());
            pstm.setDate(3, new java.sql.Date(p.getDataPagamento().getTime()));
            pstm.setInt(4, p.getFuncionario_idFfuncionario());

            if (p.getIdPagamento() != 0) {
                pstm.setInt(5, p.getIdPagamento());
            }

            pstm.execute();
            this.desconectar();
            return true;

        } catch (Exception e) {
            System.out.println("Erro ao gravar pagamento: " + e.getMessage());
            return false;
        }
    }

    public List<Pagamento> getLista() {
        List<Pagamento> lista = new ArrayList<>();
        try {
            this.conectar();
            String sql = "SELECT * FROM pagamento";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                Pagamento p = new Pagamento();
                p.setIdPagamento(rs.getInt("idPagamento"));
                p.setTipoPagamento(rs.getString("tipoPagamento"));
                p.setValor(rs.getDouble("valor"));
                p.setDataPagamento(rs.getDate("dataPagamento"));
                p.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));

                lista.add(p);
            }

            this.desconectar();

        } catch (Exception e) {
            System.out.println("Erro ao listar pagamentos: " + e.getMessage());
        }

        return lista;
    }

    public boolean excluir(int idPagamento) {
        try {
            this.conectar();
            String sql = "DELETE FROM pagamento WHERE idPagamento=?";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setInt(1, idPagamento);
            pstm.execute();
            this.desconectar();
            return true;

        } catch (Exception e) {
            System.out.println("Erro ao excluir pagamento: " + e.getMessage());
            return false;
        }
    }

    public Pagamento getCarregaPorID(int idPagamento) {
        Pagamento p = new Pagamento();
        try {
            this.conectar();
            String sql = "SELECT * FROM pagamento WHERE idPagamento=?";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setInt(1, idPagamento);
            ResultSet rs = pstm.executeQuery();

            if (rs.next()) {
                p.setIdPagamento(rs.getInt("idPagamento"));
                p.setTipoPagamento(rs.getString("tipoPagamento"));
                p.setValor(rs.getDouble("valor"));
                p.setDataPagamento(rs.getDate("dataPagamento"));
                p.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));
            }

            this.desconectar();

        } catch (Exception e) {
            System.out.println("Erro ao carregar pagamento: " + e.getMessage());
        }

        return p;
    }
    
    //Barra de busca
    public List<Pagamento> buscarPorTermo(String termo) throws Exception {
    List<Pagamento> lista = new ArrayList<>();
    String sql = "SELECT * FROM pagamento WHERE " +
                 "CAST(idPagamento AS CHAR) LIKE ? OR " +
                 "LOWER(tipoPagamento) LIKE ? OR " +
                 "CAST(valor AS CHAR) LIKE ? OR " +
                 "CAST(dataPagamento AS CHAR) LIKE ? OR " +
                 "CAST(funcionario_idFfuncionario AS CHAR) LIKE ?";

    this.conectar();
    try (PreparedStatement pstm = conn.prepareStatement(sql)) {
        String filtro = "%" + termo.toLowerCase() + "%";
        for (int i = 1; i <= 5; i++) {
            pstm.setString(i, filtro);
        }

        ResultSet rs = pstm.executeQuery();
        while (rs.next()) {
            Pagamento p = new Pagamento();
            p.setIdPagamento(rs.getInt("idPagamento"));
            p.setTipoPagamento(rs.getString("tipoPagamento"));
            p.setValor(rs.getDouble("valor")); // compatível com double
            p.setDataPagamento(rs.getDate("dataPagamento")); // java.util.Date
            p.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));
            lista.add(p);
        }
    } finally {
        this.desconectar();
    }

    return lista;
}

}
