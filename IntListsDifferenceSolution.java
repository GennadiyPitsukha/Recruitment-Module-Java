import java.util.*;
import java.util.stream.Collectors;

public class IntListsDifferenceSolution {
    public static void main(String[] args) {

        ArrayList<Integer> first = new ArrayList<>(Arrays.asList(1, 3, 3, 4, 6, 5, 4));
        ArrayList<Integer> second = new ArrayList<>(Arrays.asList(6, 3, 5, 2, 2));
        Set<Integer> target = new TreeSet<>();

        List<Integer> difference = first.stream()
                .filter(Object -> ! second.contains(Object))
                .collect(Collectors.toList());
        List<Integer> difference1 = second.stream()
                .filter(Object -> ! first.contains(Object))
                .collect(Collectors.toList());

        target.addAll(difference);
        target.addAll(difference1);
        System.out.println(target);


    }
}