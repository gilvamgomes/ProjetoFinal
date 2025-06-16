package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FuncionarioDAO extends DataBaseDAO {

    public FuncionarioDAO() throws Exception {}

    // Listar todos os funcionários
    public List<Funcionario> listar() throws Exception {
        return getLista();
    }

    public List<Funcionario> getLista() throws SQLException, ClassNotFoundException, Exception {
        List<Funcionario> lista = new ArrayList<>();
        String SQL = "SELECT * FROM funcionario";

        UsuarioDAO uDAO = new UsuarioDAO();

        this.conectar();
        try (PreparedStatement pstm = conn.prepareStatement(SQL);
             ResultSet rs = pstm.executeQuery()) {

            while (rs.next()) {
                Funcionario f = new Funcionario();
                f.setIdFuncionario(rs.getInt("idFfuncionario"));
                f.setNome(rs.getString("nome"));
                f.setDataNasc(rs.getDate("dataNasc"));
                f.setCpf(rs.getString("cpf"));
                f.setCargo(rs.getString("cargo"));
                f.setStatus(rs.getInt("status"));
                f.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));
                lista.add(f);
            }
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar funcionários: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    // Gravar ou atualizar funcionário
    public boolean gravar(Funcionario f) {
        try {
            this.conectar();
            String sql;
            if (f.getIdFuncionario() == 0) {
                sql = "INSERT INTO funcionario (nome, dataNasc, cpf, cargo, status, usuario_idUsuario) VALUES (?, ?, ?, ?, ?, ?)";
            } else {
                sql = "UPDATE funcionario SET nome=?, dataNasc=?, cpf=?, cargo=?, status=?, usuario_idUsuario=? WHERE idFfuncionario=?";
            }

            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setString(1, f.getNome());
                pstm.setDate(2, new Date(f.getDataNasc().getTime()));
                pstm.setString(3, f.getCpf());
                pstm.setString(4, f.getCargo());
                pstm.setInt(5, f.getStatus());
                pstm.setInt(6, f.getUsuario().getIdUsuario());

                if (f.getIdFuncionario() > 0) {
                    pstm.setInt(7, f.getIdFuncionario());
                }

                pstm.execute();
            }

            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao gravar funcionário: " + e);
            return false;
        }
    }

    // Carrega funcionário pelo ID
    public Funcionario getCarregaPorID(int idFuncionario) throws Exception {
        Funcionario f = new Funcionario();
        String sql = "SELECT * FROM funcionario WHERE idFfuncionario=?";

        this.conectar();
        try (PreparedStatement pstm = conn.prepareStatement(sql)) {
            pstm.setInt(1, idFuncionario);
            try (ResultSet rs = pstm.executeQuery()) {
                if (rs.next()) {
                    f.setIdFuncionario(rs.getInt("idFfuncionario"));
                    f.setNome(rs.getString("nome"));
                    f.setDataNasc(rs.getDate("dataNasc"));
                    f.setCpf(rs.getString("cpf"));
                    f.setCargo(rs.getString("cargo"));
                    f.setStatus(rs.getInt("status"));

                    UsuarioDAO uDAO = new UsuarioDAO();
                    f.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));
                }
            }
        } finally {
            this.desconectar();
        }
        return f;
    }

    // Exclusão lógica (status = 2)
    public boolean excluir(Funcionario f) {
        try {
            this.conectar();
            String sql = "UPDATE funcionario SET status=2 WHERE idFfuncionario=?";
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, f.getIdFuncionario());
                pstm.execute();
            }
            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao excluir funcionário: " + e);
            return false;
        }
    }

    // Buscar funcionário pelo idUsuario
    public Funcionario getFuncionarioPorUsuario(int idUsuario) throws Exception {
        Funcionario f = null;
        String sql = "SELECT * FROM funcionario WHERE usuario_idUsuario = ?";

        this.conectar();
        try (PreparedStatement pstm = this.conn.prepareStatement(sql)) {
            pstm.setInt(1, idUsuario);
            try (ResultSet rs = pstm.executeQuery()) {
                if (rs.next()) {
                    f = new Funcionario();
                    f.setIdFuncionario(rs.getInt("idFfuncionario"));
                    f.setNome(rs.getString("nome"));
                    f.setDataNasc(rs.getDate("dataNasc"));
                    f.setCpf(rs.getString("cpf"));
                    f.setCargo(rs.getString("cargo"));
                    f.setStatus(rs.getInt("status"));

                    UsuarioDAO uDAO = new UsuarioDAO();
                    f.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));
                }
            }
        } finally {
            this.desconectar();
        }

        return f;
    }

    // Verifica se o funcionário pertence ao usuário logado (segurança do relatório)
    public boolean usuarioPertenceFuncionario(int idFuncionario, int idUsuario) {
        boolean resultado = false;
        String sql = "SELECT * FROM funcionario WHERE idFfuncionario = ? AND usuario_idUsuario = ?";

        try {
            this.conectar();
            try (PreparedStatement pstm = this.conn.prepareStatement(sql)) {
                pstm.setInt(1, idFuncionario);
                pstm.setInt(2, idUsuario);
                try (ResultSet rs = pstm.executeQuery()) {
                    resultado = rs.next(); // achou? então pertence
                }
            }
        } catch (SQLException e) {
            System.out.println("Erro ao verificar vínculo funcionário-usuário: " + e.getMessage());
        } finally {
            try {
                this.desconectar();
            } catch (Exception e) {
                System.out.println("Erro ao desconectar: " + e.getMessage());
            }
        }

        return resultado;
    }
   //barra de busca
    public List<Funcionario> buscarPorTermo(String termo) throws Exception {
    List<Funcionario> lista = new ArrayList<>();
    String sql = "SELECT f.* " +
                 "FROM funcionario f " +
                 "JOIN usuario u ON f.usuario_idUsuario = u.idUsuario " +
                 "WHERE f.nome LIKE ? " +
                 "OR f.cpf LIKE ? " +
                 "OR f.cargo LIKE ? " +
                 "OR u.nome LIKE ? ";

    boolean filtrarPorID = false;
    boolean filtrarPorStatus = false;
    int valorID = 0;
    int valorStatus = 0;

    // Tenta identificar se é ID
    try {
        valorID = Integer.parseInt(termo);
        filtrarPorID = true;
        sql += " OR f.idFfuncionario = ? ";
    } catch (NumberFormatException e) {
        // Não é número
    }

    // Tenta identificar se é um status
    if (termo.equalsIgnoreCase("ativo")) {
        valorStatus = 1;
        filtrarPorStatus = true;
        sql += " OR f.status = ? ";
    } else if (termo.equalsIgnoreCase("inativo")) {
        valorStatus = 2;
        filtrarPorStatus = true;
        sql += " OR f.status = ? ";
    }

    this.conectar();
    UsuarioDAO uDAO = new UsuarioDAO();

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        int i = 1;
        ps.setString(i++, "%" + termo + "%");
        ps.setString(i++, "%" + termo + "%");
        ps.setString(i++, "%" + termo + "%");
        ps.setString(i++, "%" + termo + "%");

        if (filtrarPorID) {
            ps.setInt(i++, valorID);
        }
        if (filtrarPorStatus) {
            ps.setInt(i++, valorStatus);
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Funcionario f = new Funcionario();
            f.setIdFuncionario(rs.getInt("idFfuncionario"));
            f.setNome(rs.getString("nome"));
            f.setDataNasc(rs.getDate("dataNasc"));
            f.setCpf(rs.getString("cpf"));
            f.setCargo(rs.getString("cargo"));
            f.setStatus(rs.getInt("status"));
            f.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));
            lista.add(f);
        }
    } finally {
        this.desconectar();
    }

    return lista;
}

    //Barra de busca novo layout
    public List<Funcionario> buscarPorNome(String nome) throws Exception {
    List<Funcionario> lista = new ArrayList<>();
    String sql = "SELECT * FROM funcionario WHERE nome LIKE ?";

    UsuarioDAO uDAO = new UsuarioDAO();

    this.conectar();
    try (PreparedStatement pstm = conn.prepareStatement(sql)) {
        pstm.setString(1, "%" + nome + "%");
        try (ResultSet rs = pstm.executeQuery()) {
            while (rs.next()) {
                Funcionario f = new Funcionario();
                f.setIdFuncionario(rs.getInt("idFfuncionario"));
                f.setNome(rs.getString("nome"));
                f.setDataNasc(rs.getDate("dataNasc"));
                f.setCpf(rs.getString("cpf"));
                f.setCargo(rs.getString("cargo"));
                f.setStatus(rs.getInt("status"));
                f.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));
                lista.add(f);
            }
        }
    } catch (SQLException e) {
        throw new SQLException("Erro ao buscar funcionário por nome: " + e.getMessage(), e);
    } finally {
        this.desconectar();
    }

    return lista;
}
        //barra de busca
    public List<Funcionario> buscarPorTermo(String termo) throws Exception {
    List<Funcionario> lista = new ArrayList<>();
    String sql = "SELECT f.* " +
                 "FROM funcionario f " +
                 "JOIN usuario u ON f.usuario_idUsuario = u.idUsuario " +
                 "WHERE f.nome LIKE ? " +
                 "OR f.cpf LIKE ? " +
                 "OR f.cargo LIKE ? " +
                 "OR u.nome LIKE ? ";

    boolean filtrarPorID = false;
    boolean filtrarPorStatus = false;
    int valorID = 0;
    int valorStatus = 0;

    // Tenta identificar se é ID
    try {
        valorID = Integer.parseInt(termo);
        filtrarPorID = true;
        sql += " OR f.idFfuncionario = ? ";
    } catch (NumberFormatException e) {
        // Não é número
    }

    // Tenta identificar se é um status
    if (termo.equalsIgnoreCase("ativo")) {
        valorStatus = 1;
        filtrarPorStatus = true;
        sql += " OR f.status = ? ";
    } else if (termo.equalsIgnoreCase("inativo")) {
        valorStatus = 2;
        filtrarPorStatus = true;
        sql += " OR f.status = ? ";
    }

    this.conectar();
    UsuarioDAO uDAO = new UsuarioDAO();

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        int i = 1;
        ps.setString(i++, "%" + termo + "%");
        ps.setString(i++, "%" + termo + "%");
        ps.setString(i++, "%" + termo + "%");
        ps.setString(i++, "%" + termo + "%");

        if (filtrarPorID) {
            ps.setInt(i++, valorID);
        }
        if (filtrarPorStatus) {
            ps.setInt(i++, valorStatus);
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Funcionario f = new Funcionario();
            f.setIdFuncionario(rs.getInt("idFfuncionario"));
            f.setNome(rs.getString("nome"));
            f.setDataNasc(rs.getDate("dataNasc"));
            f.setCpf(rs.getString("cpf"));
            f.setCargo(rs.getString("cargo"));
            f.setStatus(rs.getInt("status"));
            f.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));
            lista.add(f);
        }
    } finally {
        this.desconectar();
    }

    return lista;
}

    
    
}
