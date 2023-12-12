/*
 *  Copyright 2022 Google LLC
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../model/filter.dart';
import '../../model/values.dart' as hardcoded;

class FilterSelectDialog extends StatefulWidget {
  const FilterSelectDialog({super.key, this.filter});

  final Filter? filter;

  @override
  State<FilterSelectDialog> createState() => _FilterSelectDialogState();
}

class _FilterSelectDialogState extends State<FilterSelectDialog> {
  @override
  void initState() {
    super.initState();

    if (widget.filter != null && !widget.filter!.isDefault) {
      _category = widget.filter!.category;
      _city = widget.filter!.city;
      _price = widget.filter!.price;
      _sort = widget.filter!.sort;
    }
  }

  String? _category;
  String? _city;
  int? _price;
  String? _sort;

  Widget _buildDropdown<T>({
    required List labels,
    required List values,
    T? selected,
    required FilterChangedCallback<T> onChanged,
  }) {
    final items = [
      for (var i = 0; i < values.length; i++)
        DropdownMenuItem<T>(value: values[i], child: Text(labels[i])),
    ];
    return DropdownButton<T>(
      items: items,
      isExpanded: true,
      value: selected,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownRow<T>({
    required List<T?> values,
    required List<String> labels,
    T? selected,
    required IconData icon,
    required FilterChangedCallback<T> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(icon),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: _buildDropdown<T>(
              labels: labels,
              values: values,
              selected: selected,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown({
    String? selected,
    required FilterChangedCallback<String> onChanged,
  }) {
    return _buildDropdownRow<String>(
      labels: ['Any Cuisine', ...hardcoded.categories],
      values: [null, ...hardcoded.categories],
      selected: selected,
      icon: Icons.fastfood,
      onChanged: onChanged,
    );
  }

  Widget _buildCityDropdown({
    String? selected,
    required FilterChangedCallback<String> onChanged,
  }) {
    return _buildDropdownRow<String>(
      labels: ['Any Location', ...hardcoded.cities],
      values: [null, ...hardcoded.cities],
      selected: selected,
      icon: Icons.location_on,
      onChanged: onChanged,
    );
  }

  Widget _buildPriceDropdown({
    int? selected,
    required FilterChangedCallback<int> onChanged,
  }) {
    return _buildDropdownRow<int>(
      labels: ['Any Price', '\$', '\$\$', '\$\$\$', '\$\$\$\$'],
      values: [null, 1, 2, 3, 4],
      selected: selected,
      icon: Icons.monetization_on,
      onChanged: onChanged,
    );
  }

  Widget _buildSortDropdown({
    String? selected,
    required FilterChangedCallback<String> onChanged,
  }) {
    return _buildDropdownRow<String>(
      labels: ['Rating', 'Reviews'],
      values: ['avgRating', 'numRatings'],
      selected: selected,
      icon: Icons.sort,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.filter_list),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Text('Filter'),
          ),
        ],
      ),
      content: SizedBox(
        width: math.min(MediaQuery.of(context).size.width, 740),
        height: math.min(MediaQuery.of(context).size.height, 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCategoryDropdown(
                selected: _category,
                onChanged: (String? value) {
                  setState(() {
                    _category = value;
                  });
                }),
            _buildCityDropdown(
                selected: _city,
                onChanged: (String? value) {
                  setState(() {
                    _city = value;
                  });
                }),
            _buildPriceDropdown(
                selected: _price,
                onChanged: (int? value) {
                  setState(() {
                    _price = value;
                  });
                }),
            _buildSortDropdown(
                selected: _sort ?? 'avgRating',
                onChanged: (String? value) {
                  setState(() {
                    _sort = value;
                  });
                }),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('CLEAR ALL'),
          onPressed: () => Navigator.pop(context, Filter()),
        ),
        ElevatedButton(
          child: const Text('ACCEPT'),
          onPressed: () => Navigator.pop(
              context,
              Filter(
                category: _category,
                city: _city,
                price: _price,
                sort: _sort,
              )),
        ),
      ],
    );
  }
}
