首先是一个父控制器，父控制上添加一个大tableView，头视图就作为tableView的tableHeaderView，这个大tableView只有一个cell，这个cell上添加一个横向滑动的scrollView，scrollView就用来添加若干个子控制器，每个子控制器都有一个tableView。其中，父控制器的大tableView必须实现下面这个手势代理方法:
 
 // 这个方法返回的是否支持多手势，当返回yes时，滑动子控制器中的scrollView时，FLYTableView也能接收滑动事件
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
     return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
 }
 
 
然后再在scrollViewDidScroll方法里，调整他们的contentOffset。
