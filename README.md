# MyResetProject

1. 어떤 문제
- 페이지네이션시 중복호출이 되던 이슈
2. 왜 놓쳤는지(이후에 어떻게 해서 이런 문제를 안놓칠수 있을지)
- 페이지네이션 관련해서 원인은 preFetch를 제대로 고려하지 않고 Observable을 생성한 지점이었습니다.
- 검색시 검색 결과 뿐 아니라, 미리 준비를 하기 위한 preFetch의 페이지네이션도 거의 같이 요청이 되고 있는데 이 부분을 생각하지 못했었습니다.
- 검색시 검색 결과를 보여줄 때, 검색 결과 뿐만이 아니라, 제가 지정한 서버요청의 display의 개수로 인해    
  preFetch 함수의 페이지네이션도 요청이 되고 있는데 이 부분을 생각하지 못했었습니다.
- 또한 prefetching이 되는 시점에 생성한 Observable이 searchBar의 text 한 번이어야 하는데,   
  변경이 될때마다 요청이 되는 Observable로 생성하고, debounce도 사용하지 않아서,   
  검색을 변경하기 위해 수정이 될때마다 요청이 되는 이슈가 발생했습니다.
- prefetching이 될 때 rx를 사용할 것이라면, 1번의 이벤트만 방출되는 형태로 작성을 했어야 했습니다.
- 검색에 따라서 요청을 할때 prefetch가 되는지 체크하고, 그에 따른 이슈가 없는지 정확하게 점검하는 기본적인 습관을 길러야 합니다.
3. 어떻게 해결해야 했는지 
- 새로운 검색이 들어가는 경우 검색이 시작되기 전 viewmodel에서 관리하는 startPage의 값을 1로 초기화 해주어야 했는데 그 부분을 해주지 않아서 발생.
- searchbar의 클리어 버튼 클릭시에도 startPage를 1로 초기화 필요.
- 요청 전 1로 초기화 해주고, 검색후 결과에 따라서 값이 반영이 되도록 수정하여 해결.
- prefetching이 될 때 요청되는 Observable을 1번의 이벤트만 방출되는 형태로 작성하여 해결.
