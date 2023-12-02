import java.io.*;

class Solution {

    static final String[] DIGITS = {
        "zero", "one", "two", "three", "four", 
        "five", "six", "seven", "eight", "nine"
    };

    static int readValue(String line, boolean part1) {
        int first = 0;
        int last = 0;

        findFirst:
        for (int i = 0;; ++i) {
            char c = line.charAt(i);
            if (Character.isDigit(c)) {
                first = c - '0';
                break;
            }
            if (part1) {
                continue;
            }
            for (int d = 1; d < 10; ++d) {
                if (line.startsWith(DIGITS[d], i)) {
                    first = d;
                    break findFirst;
                }
            }
        }
        findLast:
        for (int i = line.length() - 1;; --i) {
            char c = line.charAt(i);
            if (Character.isDigit(c)) {
                last = c - '0';
                break;
            }
            if (part1) {
                continue;
            }
            for (int d = 1; d < 10; ++d) {
                if (line.startsWith(DIGITS[d], i)) {
                    last = d;
                    break findLast;
                }
            }
        }
        return first * 10 + last;
    }

    public static void main(String[] args) {
        try (
            var fr = new FileReader("input");
            var br = new BufferedReader(fr);
        ) {
            var lines = br.lines().toList();
            int part1 = lines
                .stream()
                .mapToInt(line -> readValue(line, true))
                .sum();
            System.out.println("part 1: %d".formatted(part1));
            int part2 = lines
                .stream()
                .mapToInt(line -> readValue(line, false))
                .sum();
            System.out.println("part 2: %d".formatted(part2));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}
