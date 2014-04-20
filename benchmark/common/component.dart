library tiles_benchmark_component;

import '../utils/utils.dart';

class BenchmarkComponent extends Component {
  Map props;

  BenchmarkComponent([this.props, children]): super(null, children) {
  }

  render() {
    List levels = props["levels"];
    num level = props["level"];
    String prefix = props["prefix"];

    if (levels.length <= level) {
      return div(children: "i am ${prefix}", key: prefix);
    }

    num number = levels[level];

    var children = [];
    if (levels.length == level+1) {
      for (var i = 0; i < number; ++i) {
        children.add(div(children: "i am $prefix.$i", key: i));
      }
    } else {
      for (var i = 0; i < number; ++i) {
        children.add(component(props: {
          "levels": levels,
          "level": level + 1,
          "prefix": props["prefix"] + ".$i"
        }, key: "child$i"));
      }
    }

    ++benchmark.rendered;
    if (benchmark.rendered == benchmark.toRender) {
      benchmark.stop(Benchmark.ALLRENDERED);
    }

    return div(children: children);
  }

}

var registeredComponent = registerComponent(({props, children}) => new BenchmarkComponent(props, children));

var component = ({props, children, key, Map listeners}) {
  ++benchmark.toRender;
  return registeredComponent(props: props, children: children, key: key, listeners: listeners);
};
