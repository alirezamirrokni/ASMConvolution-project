//Student: Alireza Mirrokni (student number: 401106617)
//Instructor: Prof. Jahangir
//Sharif University Of Technology
//Winter 2024

import java.util.ArrayList;
import java.util.Scanner;

public class ConvolutionUsingDotProduct {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        ArrayList<ArrayList<Double>> kernel = new ArrayList<>();
        ArrayList<ArrayList<Double>> matrix = new ArrayList<>();
        ArrayList<ArrayList<Double>> result;
        int n, k, convolutionType, resultMatrixSize;
        long startTime, endTime, executionTime;

        k = scanner.nextInt();
        for (int i = 0; i < k; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < k; j++) {
                row.add(scanner.nextDouble());
            }
            kernel.add(row);
        }

        n = scanner.nextInt();
        for (int i = 0; i < n; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < n; j++) {
                row.add(scanner.nextDouble());
            }
            matrix.add(row);
        }

        convolutionType = scanner.nextInt();

        if (convolutionType == 1) {
            resultMatrixSize = n - k + 1;

            startTime = System.nanoTime();
            result = regularConvolution(kernel, matrix, k, resultMatrixSize);
            endTime = System.nanoTime();
        } else {
            resultMatrixSize = n;

            startTime = System.nanoTime();
            result = edgeHandlingConvolution(kernel, matrix, k, n, resultMatrixSize, convolutionType);
            endTime = System.nanoTime();
        }

        for (int i = 0; i < resultMatrixSize; i++) {
            for (int j = 0; j < resultMatrixSize; j++) {
                System.out.print(result.get(i).get(j));
                System.out.print(" ");
            }
            System.out.println();
        }

        executionTime = (endTime - startTime);
        System.out.println("\nexecution time in nanoseconds:\n" + executionTime);

    }

    private static ArrayList<ArrayList<Double>> edgeHandlingConvolution(ArrayList<ArrayList<Double>> kernel, ArrayList<ArrayList<Double>> matrix, int k, int n, int resultMatrixSize, int convolutionType) {
        ArrayList<ArrayList<Double>> result = new ArrayList<>();

        int edge = -Math.floorDiv(k, 2);

        for (int i = edge; i < resultMatrixSize + edge; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = edge; j < resultMatrixSize + edge; j++) {
                double sum = 0;
                for (int z = i; z < i + k; z++) {
                    for (int t = j; t < j + k; t++) {
                        ArrayList<Integer> adjustedCoordinates = adjustCoordinates(z, t, n, convolutionType);
                        int adjustedZ = adjustedCoordinates.get(0);
                        int adjustedT = adjustedCoordinates.get(1);
                        if (adjustedZ < 0) continue;
                        sum += matrix.get(adjustedZ).get(adjustedT) * kernel.get(z - i).get(t - j);
                    }
                }
                row.add(sum);
            }
            result.add(row);
        }

        return result;
    }

    private static ArrayList<Integer> adjustCoordinates(int row, int column, int n, int convolutionType) {
        ArrayList<Integer> coordinates = new ArrayList<>();

        if (convolutionType == 2) {
            if (row < 0) row = 0;
            else if (row >= n) row = n - 1;
            if (column < 0) column = 0;
            else if (column >= n) column = n - 1;
        } else if (convolutionType == 3) {
            if (row < 0) row = -row - 1;
            else if (row >= n) row = 2 * n - row - 1;
            if (column < 0) column = -column - 1;
            else if (column >= n) column = 2 * n - column - 1;
        } else {
            if (row < 0 || row >= n || column < 0 || column >= n) row = -1;
        }

        coordinates.add(row);
        coordinates.add(column);
        return coordinates;
    }

    private static ArrayList<ArrayList<Double>> regularConvolution(ArrayList<ArrayList<Double>> kernel, ArrayList<ArrayList<Double>> matrix, int k, int resultMatrixSize) {
        ArrayList<ArrayList<Double>> result = new ArrayList<>();
        for (int i = 0; i < resultMatrixSize; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < resultMatrixSize; j++) {
                double sum = 0;
                for (int z = i; z < i + k; z++) {
                    for (int t = j; t < j + k; t++) {
                        sum += matrix.get(z).get(t) * kernel.get(z - i).get(t - j);
                    }
                }
                row.add(sum);
            }
            result.add(row);
        }

        return result;
    }


}
