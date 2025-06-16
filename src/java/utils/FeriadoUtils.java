package utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class FeriadoUtils {

    public static class Feriado {
        private String date;
        private String name;
        private String type;

        public LocalDate getLocalDate() {
            return LocalDate.parse(date);
        }

        public String getType() {
            return type;
        }

        // Considera apenas Nacional e Estadual
        public boolean isRelevante(String estado) {
            return type.equalsIgnoreCase("national")
                || type.equalsIgnoreCase("state - " + estado);
        }
    }

    // Agora só recebe o ano e o estado (ex: 2025, "DF")
    public static List<LocalDate> buscarFeriadosRelevantes(int ano, String estado) {
        List<LocalDate> datas = new ArrayList<>();

        try {
            URL url = new URL("https://brasilapi.com.br/api/feriados/v1/" + ano);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            // 👇 Isso aqui resolve o erro 403
            con.setRequestProperty("User-Agent", "Mozilla/5.0");

            BufferedReader in = new BufferedReader(
                new InputStreamReader(con.getInputStream())
            );

            String inputLine;
            StringBuilder resposta = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                resposta.append(inputLine);
            }
            in.close();

            Gson gson = new Gson();

            List<Feriado> feriados = gson.fromJson(
                resposta.toString(), new TypeToken<List<Feriado>>(){}.getType()
            );
            
            

            datas = feriados.stream()
                    .filter(f -> f.isRelevante(estado))
                    .map(Feriado::getLocalDate)
                    .collect(Collectors.toList());

        } catch (Exception e) {
            System.err.println("Erro ao buscar feriados: " + e.getMessage());
        }

        return datas;
    }
}
