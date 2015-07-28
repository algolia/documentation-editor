angular.module('documentationEditorApp', ['ngFileUpload'])
  .config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode({ enabled: true, requireBase: false, rewriteLinks: false });
  }])
  .controller('EditorController', ['$scope', '$http', '$window', '$location', function($scope, $http, $window, $location) {
    $scope.sections = [];
    $scope.undoRedo = [];
    $scope.id = 0;
    $scope.source = '';

    $scope.nextID = 0;
    function getNextID() {
      return $scope.nextID++;
    }

    function parse(source) {
      var lines = source.split("\n");
      var currentBlock = null, blockContent = '';
      var sections = [];
      for (var i = 0; i < lines.length; ++i) {
        var line = lines[i];
        if (line.indexOf('[block:') === 0) {
          currentBlock = line.substring(7, line.length - 1);
        } else if (line.indexOf('[/block]') === 0) {
          sections.push({
            id: getNextID(),
            type: currentBlock,
            content: JSON.parse(blockContent)
          });
          currentBlock = null;
          blockContent = '';
        } else if (currentBlock != null) {
          blockContent = blockContent + line + '\n';
        } else {
          if (sections.length > 0 && sections[sections.length - 1].type === 'text') {
            sections[sections.length - 1].content = (sections[sections.length - 1].content + "\n" + line).replace(/\n{2,}$/, "\n\n");
          } else if (line) {
            sections.push({
              id: getNextID(),
              type: 'text',
              content: line
            });
          }
        }
      }
      return sections;
    }

    function serialize(sections) {
      var data = [];
      $.each(sections, function(i, section) {
        if (section.type === 'text') {
          data.push(section.content + "\n");
        } else {
          data.push('[block:' + section.type + ']');
          data.push(JSON.stringify(section.content));
          data.push("[/block]\n");
        }
      });
      return data.join("\n");
    }

    $scope.init = function(id, path) {
      $scope.id = id;
      $scope.path = path;

      $http.get($scope.path + '/admin/' + id).then(function(content) {
        $scope.source = content.data.source;
        $scope.sections = parse($scope.source);
      });
    };

    $scope.rawView =  false;
    $scope.toggleView = function($event) {
      $event.preventDefault();
      $scope.undoRedo = [];
      if ($scope.rawView) {
        $scope.sections = parse(this.source);
      } else {
        $scope.source = serialize($scope.sections);
      }
      $scope.rawView = !$scope.rawView;
    };

    $scope.undo = function($event) {
      $event.preventDefault();
      if ($scope.undoRedo.length === 0) {
        return;
      }
      var o = $scope.undoRedo.pop();
      if (o.type === 'addSection') {
        $scope.sections = $.grep($scope.sections, function(e) { return e.id !== o.data.obj.id });
      } else if (o.type === 'deleteSection') {
        $scope.sections = o.data.sections;
      } else if (o.type === 'deleteLanguage' || o.type === 'addLanguage') {
        var index = getIndex(o.data.id);
        var obj = {
          id: $scope.sections[index].id,
          type: 'code',
          content: {
            codes: o.data.codes
          }
        };
        $scope.sections = [].concat($scope.sections.slice(0, index), [obj], $scope.sections.slice(index + 1));
      } else if (o.type === 'deleteColumn' || o.type === 'addColumn' || o.type === 'addRow' || o.type === 'deleteRow') {
        var index = getIndex(o.data.id);
        $scope.sections[index] = {
          id: $scope.sections[index].id,
          type: 'parameters',
          content: o.data.content
        };
      } else if (o.type === 'moveDown') {
        var index = getIndex(o.data.id);
        var before = $scope.sections[index - 1];
        $scope.sections[index - 1] = $scope.sections[index];
        $scope.sections[index] = before;
      } else if (o.type === 'moveUp') {
        var index = getIndex(o.data.id);
        var after = $scope.sections[index + 1];
        $scope.sections[index + 1] = $scope.sections[index];
        $scope.sections[index] = after;
      }
    }

    function getIndex(id) {
      for (var i = 0; i < $scope.sections.length; ++i) {
        if ($scope.sections[i].id === id) {
          return i;
        }
      }
      return -1;
    }

    $scope.moveUp = function($event, id) {
      $event.preventDefault();
      var index = getIndex(id);
      if (index > 0) {
        $scope.undoRedo.push({
          type: 'moveUp',
          data: {
            id: id
          }
        });
        var before = $scope.sections[index - 1];
        $scope.sections[index - 1] = $scope.sections[index];
        $scope.sections[index] = before;
      }
    };

    $scope.moveDown = function($event, id) {
      $event.preventDefault();
      var index = getIndex(id);
      if (index < $scope.sections.length - 1) {
        $scope.undoRedo.push({
          type: 'moveDown',
          data: {
            id: id
          }
        });
        var after = $scope.sections[index + 1];
        $scope.sections[index + 1] = $scope.sections[index];
        $scope.sections[index] = after;
      }
    };

    function add(id, obj) {
      $scope.undoRedo.push({
        type: 'addSection',
        data: {
          id: id,
          obj: obj
        }
      });
      var index = getIndex(id);
      $scope.sections = [].concat($scope.sections.slice(0, index + 1), [obj], $scope.sections.slice(index + 1));
    }

    $scope.addText = function($event, id) {
      $event.preventDefault();
      add(id, { id: getNextID(), type: 'text', content: 'FIXME' });
    };

    $scope.addCallout = function($event, type, id) {
      $event.preventDefault();
      add(id, {
        id: getNextID(),
        type: 'callout',
        content: {
          type: type,
          body: 'FIXME'
        }
      });
    };

    $scope.addCode = function($event, id) {
      $event.preventDefault();
      add(id, {
        id: getNextID(),
        type: 'code',
        content: {
          codes: [
            {
              language: 'fixme',
              code: '// FIXME'
            }
          ]
        }
      });
    };

    $scope.getIntegerIterator = function(v) {
      var a = [];
      for (var i = 0; i < v; ++i) {
        a.push(i);
      }
      return a;
    };

    $scope.deleteSection = function($event, id) {
      $event.preventDefault();
      $scope.undoRedo.push({
        type: 'deleteSection',
        data: {
          sections: $scope.sections
        }
      });
      $scope.sections = $.grep($scope.sections, function(e) { return e.id !== id });
    };

    $scope.deleteLanguage = function($event, id, languageIndex) {
      $event.preventDefault();
      var index = getIndex(id);
      $scope.undoRedo.push({
        type: 'deleteLanguage',
        data: {
          id: id,
          codes: $scope.sections[index].content.codes
        }
      });
      $scope.sections[index].content.codes = $.grep($scope.sections[index].content.codes, function(e, i) { return i !== languageIndex; });
    };

    $scope.addLanguage = function($event, id) {
      $event.preventDefault();
      var index = getIndex(id);
      $scope.undoRedo.push({
        type: 'addLanguage',
        data: {
          id: id,
          codes: $scope.sections[index].content.codes
        }
      });
      $scope.sections[index].content.codes = [].concat($scope.sections[index].content.codes, [{ language: 'FIXME:language|label', code: '// FIXME' }]);
    };

    $scope.imageToAddAfter = 0;
    $scope.saveImagePosition = function(id) {
      $scope.imageToAddAfter = id;
    };
    $scope.addImage = function(url) {
      $('#editor-images').modal('hide');
      add($scope.imageToAddAfter, {
        type: 'image',
        content: {
          images: [
            {
              image: [url]
            }
          ]
        }
      });
    };

    $scope.addColumn = function($event, id) {
      $event.preventDefault();
      var index = getIndex(id);
      var section = $scope.sections[index];

      $scope.undoRedo.push({
        type: 'addColumn',
        data: {
          id: id,
          content: {
            data: section.content.data,
            cols: section.content.cols,
            rows: section.content.rows
          }
        }
      });

      var col = section.content.cols;
      section.content.data['h-' + col] = section.content.data['h-' + col] || 'FIXME';
      section.content.cols = section.content.cols + 1;
      for (var i = 0; i < section.content.rows; ++i) {
        section.content.data[i + '-' + col] = section.content.data[i + '-' + col] || '';
      }
    };

    $scope.deleteColumn = function($event, id) {
      $event.preventDefault();
      var index = getIndex(id);
      var section = $scope.sections[index];

      $scope.undoRedo.push({
        type: 'deleteColumn',
        data: {
          id: id,
          content: {
            data: section.content.data,
            cols: section.content.cols,
            rows: section.content.rows
          }
        }
      });

      section.content.cols = section.content.cols - 1;
    };

    $scope.addRow = function($event, id) {
      $event.preventDefault();
      var index = getIndex(id);
      var section = $scope.sections[index];

      $scope.undoRedo.push({
        type: 'addRow',
        data: {
          id: id,
          content: {
            data: section.content.data,
            cols: section.content.cols,
            rows: section.content.rows
          }
        }
      });

      var rows = section.content.rows;
      section.content.rows = section.content.rows + 1;
      for (var i = 0; i < section.content.cols; ++i) {
        section.content.data[rows + '-' + i] = section.content.data[rows + '-' + i] || '';
      }
    };

    $scope.deleteRow = function($event, id) {
      $event.preventDefault();
      var index = getIndex(id);
      var section = $scope.sections[index];

      $scope.undoRedo.push({
        type: 'deleteRow',
        data: {
          id: id,
          content: {
            data: section.content.data,
            cols: section.content.cols,
            rows: section.content.rows
          }
        }
      });

      section.content.rows = section.content.rows - 1;
    };

    $scope.addIf = function($event, id) {
      $event.preventDefault();
      add(id, {
        id: getNextID(),
        type: 'if',
        content: {
          condition: 'FIXME:language'
        }
      });
    };

    $scope.addIfNot = function($event, id) {
      $event.preventDefault();
      add(id, {
        id: getNextID(),
        type: 'ifnot',
        content: {
          condition: 'FIXME:language'
        }
      });
    };

    $scope.addEndIf = function($event, id) {
      $event.preventDefault();
      add(id, {
        id: getNextID(),
        type: 'endif',
        content: {}
      });
    };

    $scope.addTable = function($event, id) {
      $event.preventDefault();
      add(id, {
        id: getNextID(),
        type: 'parameters',
        content: {
          cols: 2,
          rows: 2,
          data: {
            'h-0': 'FIXME 1',
            'h-1': 'FIXME 2',
            '0-0': '',
            '0-1': '',
            '1-0': '',
            '1-1': ''
          }
        }
      });
    };

    function save(preview) {
      return $http.post($scope.path + '/admin/' + $scope.id, { data: serialize($scope.sections), preview: preview });
    }

    $scope.preview = function($event) {
      $event.preventDefault();
      save(true).then(function(content) {
        $window.open($scope.path + '/admin/' + content.data.id + '/preview');
        $location.path($scope.path + '/admin/' + content.data.id + '/edit').replace();
      });
    };

    $scope.publish = function($event) {
      $event.preventDefault();

      if (confirm('Are you sure you want to publish this page?')) {
        save(false).then(function(content) {
          $window.location.href = $scope.path + '/' + content.data.slug;
        });
      }
    }

  }]).controller('ImageUploaderController', ['$scope', 'Upload', function($scope, Upload) {
    $scope.caption = ''
    $scope.files = [];

    $scope.$watch('files', function () {
      $scope.upload($scope.files);
    });

    $scope.upload = function(files) {
      if (files && files.length) {
        for (var i = 0; i < files.length; i++) {
          var file = files[i];
          Upload.upload({
            url: $scope.$parent.path + '/admin/images',
            fields: { caption: $scope.caption },
            file: file
          }).success(function (data, status, headers, config) {
            console.log('uploaded', data);
            $scope.$parent.addImage(data.url);
          }).error(function (data, status, headers, config) {
            console.log('error', data);
            alert('Error status: ' + status);
          })
        }
      }
    };

  }]).controller('HistoryController', ['$scope', '$http', '$sce', function($scope, $http, $sce) {
    $scope.pages = [];

    $scope.init = function(slug, path) {
      $http.get(path + '/admin/' + slug + '/versions').then(function(content) {
        $scope.pages = content.data.pages;
        $scope.diff = {
          cur: 0,
          prev: 1
        };
      });
      $scope.path = path;
    };

    $scope.$watchCollection('diff', function(diff) {
      if (!diff) {
        return;
      }
      $http.get($scope.path + '/admin/' + $scope.pages[diff.prev].id + '/' + $scope.pages[diff.cur].id + '/diff').then(function(content) {
        $scope.content = $sce.trustAsHtml(content.data);
      });
    });
  }]).directive('contenteditable', ['$document', function($document) {
    return {
      require: 'ngModel',
      link: function(scope, element, attrs, ngModel) {
        function read() {
          // use the HTML form to keep the new lines
          var text = element.html();
          // replace the HTML newlines by \n
          text = text.replace(/<div>/g, '').replace(/<\/div>/g, "\n").replace(/<br>/g, "\n").replace(/\n{2,}$/, '');
          // replace also all HTML entities
          text = $('<div />').html(text).text();
          ngModel.$setViewValue(text);
        }

        ngModel.$render = function() {
          element.text(ngModel.$viewValue || "");
        };

        element.bind("blur keyup change", function() {
          scope.$apply(read);
        });

        // force every copy/paste to be plain/text
        element.bind('paste', function(e) {
          e.preventDefault();
          var text = (e.originalEvent || e).clipboardData.getData('text/plain') || '';
          $document[0].execCommand("insertHTML", false, text);
        });
      }
    };
  }])
;
