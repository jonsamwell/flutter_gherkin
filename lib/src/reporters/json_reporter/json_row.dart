class JsonRow {
  List<String> cells = [];

  JsonRow(this.cells);

  Map<String, dynamic> toJson() {
    return {
      "cells": cells,
    };
  }
}