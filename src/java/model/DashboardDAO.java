package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.DataBaseDAO;

public class DashboardDAO {

    private Connection conn;

    public DashboardDAO() throws Exception {
        DataBaseDAO db = new DataBaseDAO();  // usa o DAO já existente
        db.conectar();
        this.conn = db.conn;
    }

    public int contarFuncionarios() {
        String sql = "SELECT COUNT(*) FROM funcionario";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Erro ao contar funcionários: " + e.getMessage());
        }
        return 0;
    }

    public int contarFerias() {
        String sql = "SELECT COUNT(*) FROM ferias";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Erro ao contar férias: " + e.getMessage());
        }
        return 0;
    }

    public int contarRegistrosPonto() {
        String sql = "SELECT COUNT(*) FROM registro_ponto";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Erro ao contar registros de ponto: " + e.getMessage());
        }
        return 0;
    }

    public int contarBeneficios() {
        String sql = "SELECT COUNT(*) FROM beneficio";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Erro ao contar benefícios: " + e.getMessage());
        }
        return 0;
    }

    public int contarImpostos() {
        String sql = "SELECT COUNT(*) FROM imposto";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Erro ao contar impostos: " + e.getMessage());
        }
        return 0;
    }
}
