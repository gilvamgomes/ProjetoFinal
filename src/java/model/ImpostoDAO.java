package model;

import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class ImpostoDAO extends DataBaseDAO {

    public ImpostoDAO() throws Exception {}

    public boolean gravar(Imposto i) {
        try {
            this.conectar();
            String sql;
            if (i.getIdImposto() == 0) {
                sql = "INSERT INTO imposto (descricao, tipo, faixa_inicio, faixa_fim, aliquota, parcela_deduzir) VALUES (?, ?, ?, ?, ?, ?)";
            } else {
                sql = "UPDATE imposto SET descricao=?, tipo=?, faixa_inicio=?, faixa_fim=?, aliquota=?, parcela_deduzir=? WHERE idImposto=?";
            }
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setString(1, i.getDescricao());
            pstm.setString(2, i.getTipo());
            pstm.setBigDecimal(3, i.getFaixaInicio());
            pstm.setBigDecimal(4, i.getFaixaFim());
            pstm.setBigDecimal(5, i.getAliquota());
            pstm.setBigDecimal(6, i.getParcelaDeduzir());
            if (i.getIdImposto() != 0) {
                pstm.setInt(7, i.getIdImposto());
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
                i.setDescricao(rs.getString("descricao"));
                i.setTipo(rs.getString("tipo"));
                i.setFaixaInicio(rs.getBigDecimal("faixa_inicio"));

                BigDecimal faixaFim = rs.getBigDecimal("faixa_fim");
                i.setFaixaFim(rs.wasNull() ? null : faixaFim);

                i.setAliquota(rs.getBigDecimal("aliquota"));
                i.setParcelaDeduzir(rs.getBigDecimal("parcela_deduzir"));

                // Log pra ver se está carregando
                System.out.println(">> Imposto carregado: " + i.getDescricao());

                lista.add(i);
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao listar impostos: " + e.getMessage());
        }
        return lista;
    }

    public List<Imposto> listarPorTipo(String tipo) {
        List<Imposto> lista = new ArrayList<>();
        try {
            this.conectar();
            String sql = "SELECT * FROM imposto WHERE tipo = ? ORDER BY faixa_inicio ASC";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setString(1, tipo);
            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                Imposto i = new Imposto();
                i.setIdImposto(rs.getInt("idImposto"));
                i.setDescricao(rs.getString("descricao"));
                i.setTipo(rs.getString("tipo"));
                i.setFaixaInicio(rs.getBigDecimal("faixa_inicio"));

                BigDecimal faixaFim = rs.getBigDecimal("faixa_fim");
                i.setFaixaFim(rs.wasNull() ? null : faixaFim);

                i.setAliquota(rs.getBigDecimal("aliquota"));
                i.setParcelaDeduzir(rs.getBigDecimal("parcela_deduzir"));

                lista.add(i);
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao listar por tipo: " + e.getMessage());
        }
        return lista;
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
                i.setDescricao(rs.getString("descricao"));
                i.setTipo(rs.getString("tipo"));
                i.setFaixaInicio(rs.getBigDecimal("faixa_inicio"));

                BigDecimal faixaFim = rs.getBigDecimal("faixa_fim");
                i.setFaixaFim(rs.wasNull() ? null : faixaFim);

                i.setAliquota(rs.getBigDecimal("aliquota"));
                i.setParcelaDeduzir(rs.getBigDecimal("parcela_deduzir"));
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao carregar imposto por ID: " + e.getMessage());
        }
        return i;
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
}
