import 'package:ecommerce_app/data/entity/sort_type.dart';
import 'package:ecommerce_app/data/entity/view_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortTypeView extends StatelessWidget {
  final List<String> sortList;
  final SortType sortType;
  final ViewType viewType;
  final Function() onSortClicked;
  final Function() onViewTypeClicked;

  const SortTypeView({
    Key? key,
    required this.sortList,
    required this.sortType,
    required this.onSortClicked,
    required this.onViewTypeClicked,
    required this.viewType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
        border: Border(
          top: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      height: 56,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSortClicked,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    const Icon(CupertinoIcons.sort_down),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'مرتب سازی',
                          style: themeData.textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          sortList[sortType.index],
                          style: themeData.textTheme.caption!.copyWith(
                            fontSize: 12.5,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
          SizedBox(
            height: 56,
            width: 56,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onViewTypeClicked,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(viewType == ViewType.grid
                      ? CupertinoIcons.square_grid_2x2
                      : CupertinoIcons.square),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
