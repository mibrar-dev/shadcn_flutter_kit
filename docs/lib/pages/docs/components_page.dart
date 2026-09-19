import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../docs_page.dart';
import 'blocks.dart';
import 'components_registry.dart';
import 'component_examples.dart';
import 'component_previews.dart';
import '../../ui/shadcn/components/control/button/button.dart'
    as shadcn_buttons;
import '../../ui/shadcn/shared/primitives/text.dart';

class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  late Future<List<RegistryComponent>> _future;

  @override
  void initState() {
    super.initState();
    _future = loadRegistryComponents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RegistryComponent>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final components = snapshot.data!
            .where((component) => originalComponentIds.contains(component.id))
            .toList();
        components.sort((a, b) => a.name.compareTo(b.name));

        return DocsPage(
          name: 'components',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Components').h1(),
              const SizedBox(height: 12),
              const DocsParagraph(
                text:
                    'Here you can find all the components available in the library. We are working on adding more components.',
              ),
              const SizedBox(height: 20),
              _ComponentNameGrid(components: components),
            ],
          ),
        );
      },
    );
  }
}

class _ComponentNameGrid extends StatelessWidget {
  final List<RegistryComponent> components;

  const _ComponentNameGrid({required this.components});

  int _columnCountForWidth(double width) {
    if (width >= 980) return 3;
    if (width >= 620) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnCountForWidth(constraints.maxWidth);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: components.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: 36,
            crossAxisSpacing: 28,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            return _ComponentNameLink(component: components[index]);
          },
        );
      },
    );
  }
}

class _ComponentNameLink extends StatelessWidget {
  final RegistryComponent component;

  const _ComponentNameLink({required this.component});

  String _toKebabCase(String value) {
    return value.replaceAll('_', '-');
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: shadcn_buttons.LinkButton(
              onPressed: () =>
                  context.go('/components/${_toKebabCase(component.id)}'),
              alignment: Alignment.centerLeft,
              size: shadcn_buttons.ButtonSize.small,
              density: shadcn_buttons.ButtonDensity.dense,
              child: Text(
                component.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (component.status != 'Stable') ...[
            const SizedBox(width: 8),
            buildStatusBadge(component.status),
          ],
        ],
      ),
    );
  }
}
