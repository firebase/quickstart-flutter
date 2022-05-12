typedef FilterChangedCallback<T> = void Function(T? newValue);

class Filter {
  final String? city;
  final int? price;
  final String? category;
  final String? sort;

  bool get isDefault {
    return (city == null && price == null && category == null && sort == null);
  }

  Filter({
    this.city,
    this.price,
    this.category,
    this.sort,
  });
}
