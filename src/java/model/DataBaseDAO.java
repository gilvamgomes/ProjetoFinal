package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBaseDAO {

    // URL, USUÁRIO E SENHA DO BANCO
    private static final String URL = "jdbc:mysql://localhost:3306/projetofinal";
    private static final String USER = "root";
    private static final String SENHA = "";

    public Connection conn;

    // Construtor que carrega o driver do MySQL
    public DataBaseDAO() throws ClassNotFoundException {
        Class.forName("com.mysql.jdbc.Driver");
    }

    // Método para conectar ao banco de dados
    public void conectar() throws SQLException {
        if (conn == null || conn.isClosed()) {
            conn = DriverManager.getConnection(URL, USER, SENHA);
        }
    }

    // Método para desconectar do banco de dados
    public void desconectar() {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Erro ao fechar a conexão: " + e.getMessage());
            }
        }
    }
}