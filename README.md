# MyResetProject

1. 어떤 문제
- 페이지네이션시 중복호출이 되던 이슈
2. 왜 놓쳤는지(이후에 어떻게 해서 이런 문제를 안놓칠수 있을지)
- 검색시 검색 결과 뿐 아니라, 미리 준비를 하기 위한 preFetch의 페이지네이션도 거의 같이 요청이 되고 있는데 이 부분을 생각하지 못했다.
- 검색에 따라서 요청을 할때 prefetch가 되는지 체크하고, 그에 따른 이슈가 없는지 점검도 같이하는 기본적인 습관을 길러야 한다
3. 어떻게 해결해야 했는지 
- 새로운 검색이 들어가는 경우 검색이 시작되기 전 viewmodel에서 관리하는 startPage의 값을 1로 초기화 해주어야 했는데 그 부분을 해주지 않아서 발생.
- searchbar의 클리어 버튼 클릭시에도 startPage를 1로 초기화 필요.
- 요청 전 1로 초기화 해주고, 검색후 결과에 따라서 값이 반영이 되도록 수정하여 해결.
